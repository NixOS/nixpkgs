{ config, lib, stdenv, fetchurl, fetchpatch, pkg-config, libiconv
, libintl, expat, zlib, libpng, pixman, fontconfig, freetype
, x11Support? !stdenv.isDarwin, libXext, libXrender
, gobjectSupport ? true, glib
, xcbSupport ? x11Support, libxcb, xcbutil # no longer experimental since 1.12
, libGLSupported ? lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms
, glSupport ? x11Support && config.cairo.gl or (libGLSupported && stdenv.isLinux)
, libGL ? null # libGLU libGL is no longer a big dependency
, pdfSupport ? true
, darwin
}:

assert glSupport -> x11Support && libGL != null;

let
  version = "1.16.0";
  inherit (lib) optional optionals;
in stdenv.mkDerivation rec {
  pname = "cairo";
  inherit version;

  src = fetchurl {
    url = "https://cairographics.org/${if lib.mod (builtins.fromJSON (lib.versions.minor version)) 2 == 0 then "releases" else "snapshots"}/${pname}-${version}.tar.xz";
    sha256 = "0c930mk5xr2bshbdljv005j3j8zr47gqmkry3q6qgvqky6rjjysy";
  };

  patches = [
    # Fixes CVE-2018-19876; see Nixpkgs issue #55384
    # CVE information: https://nvd.nist.gov/vuln/detail/CVE-2018-19876
    # Upstream PR: https://gitlab.freedesktop.org/cairo/cairo/merge_requests/5
    #
    # This patch is the merged commit from the above PR.
    (fetchpatch {
      name   = "CVE-2018-19876.patch";
      url    = "https://gitlab.freedesktop.org/cairo/cairo/commit/6edf572ebb27b00d3c371ba5ae267e39d27d5b6d.patch";
      sha256 = "112hgrrsmcwxh1r52brhi5lksq4pvrz4xhkzcf2iqp55jl2pb7n1";
    })

    # Fix PDF output.
    # https://gitlab.freedesktop.org/cairo/cairo/issues/342
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/cairo/cairo/commit/5e34c5a9640e49dcc29e6b954c4187cfc838dbd1.patch";
      sha256 = "yCwsDUY7efVvOZkA6a0bPS+RrVc8Yk9bfPwWHeOjq5o=";
    })

    # Fixes CVE-2020-35492; see https://github.com/NixOS/nixpkgs/issues/120364.
    # CVE information: https://nvd.nist.gov/vuln/detail/CVE-2020-35492
    # Upstream PR: https://gitlab.freedesktop.org/cairo/cairo/merge_requests/85
    (fetchpatch {
      name = "CVE-2020-35492.patch";
      includes = [ "src/cairo-image-compositor.c" ];
      url = "https://github.com/freedesktop/cairo/commit/78266cc8c0f7a595cfe8f3b694bfb9bcc3700b38.patch";
      sha256 = "048nzfz7rkgqb9xs0dfs56qdw7ckkxr87nbj3p0qziqdq4nb6wki";
    })

    # Workaround https://gitlab.freedesktop.org/cairo/cairo/-/issues/121
    ./skip-configure-stderr-check.patch

    # Fixes cairo crash on macOS Big Sur
    # Upstream PR: https://gitlab.freedesktop.org/cairo/cairo/-/issues/420
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/cairo/cairo/-/commit/e22d7212acb454daccc088619ee147af03883974.diff";
      sha256 = "sha256-8G98nsPz3MLEWPDX9F0jKgXC4hC4NNdFQLSpmW3ay2s=";
    })

    # Fix unexpected color addition on grayscale images (usually text).
    # Upstream fix: https://gitlab.freedesktop.org/cairo/cairo/-/merge_requests/114
    # Can be removed after 1.18 release
    (fetchpatch {
      name = "fix-grayscale-anialias.patch";
      url = "https://gitlab.freedesktop.org/cairo/cairo/-/commit/4f4d89506f58a64b4829b1bb239bab9e46d63727.diff";
      sha256 = "sha256-mbTg67e7APfdELsuMAgXdY3xokWbGtHF7VDD5UyYqKM=";
    })
  ];

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev"; # very small
  separateDebugInfo = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libiconv
    libintl
  ] ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreGraphics
    CoreText
    ApplicationServices
    Carbon
  ]);

  propagatedBuildInputs = [ fontconfig expat freetype pixman zlib libpng ]
    ++ optionals x11Support [ libXext libXrender ]
    ++ optionals xcbSupport [ libxcb xcbutil ]
    ++ optional gobjectSupport glib
    ++ optional glSupport libGL
    ; # TODO: maybe liblzo but what would it be for here?

  configureFlags = [
    "--enable-tee"
  ] ++ (if stdenv.isDarwin then [
    "--disable-dependency-tracking"
    "--enable-quartz"
    "--enable-quartz-font"
    "--enable-quartz-image"
    "--enable-ft"
  ] else (optional xcbSupport "--enable-xcb"
    ++ optional glSupport "--enable-gl"
    ++ optional pdfSupport "--enable-pdf"
  )) ++ optional (!x11Support) "--disable-xlib";

  preConfigure =
  # On FreeBSD, `-ldl' doesn't exist.
    lib.optionalString stdenv.isFreeBSD
       '' for i in "util/"*"/Makefile.in" boilerplate/Makefile.in
          do
            cat "$i" | sed -es/-ldl//g > t
            mv t "$i"
          done
       ''
    +
    ''
    # Work around broken `Requires.private' that prevents Freetype
    # `-I' flags to be propagated.
    sed -i "src/cairo.pc.in" \
        -es'|^Cflags:\(.*\)$|Cflags: \1 -I${freetype.dev}/include/freetype2 -I${freetype.dev}/include|g'
    substituteInPlace configure --replace strings $STRINGS
    '';

  enableParallelBuilding = true;

  doCheck = false; # fails

  postInstall = lib.optionalString stdenv.isDarwin glib.flattenInclude;

  meta = with lib; {
    description = "A 2D graphics library with support for multiple output devices";

    longDescription = ''
      Cairo is a 2D graphics library with support for multiple output
      devices.  Currently supported output targets include the X
      Window System, Quartz, Win32, image buffers, PostScript, PDF,
      and SVG file output.  Experimental backends include OpenGL
      (through glitz), XCB, BeOS, OS/2, and DirectFB.

      Cairo is designed to produce consistent output on all output
      media while taking advantage of display hardware acceleration
      when available (e.g., through the X Render Extension).
    '';

    homepage = "http://cairographics.org/";

    license = with licenses; [ lgpl2Plus mpl10 ];

    platforms = platforms.all;
  };
}
