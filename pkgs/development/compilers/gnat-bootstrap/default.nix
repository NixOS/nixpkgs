{
  stdenv,
  lib,
  autoPatchelfHook,
  fetchzip,
  xz,
  ncurses5,
  ncurses,
  readline,
  gmp,
  mpfr,
  expat,
  libipt,
  zlib,
  dejagnu,
  sourceHighlight,
  python3,
  elfutils,
  guile,
  glibc,
  zstd,
  majorVersion,
}:

let
  throwUnsupportedSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation (
  finalAttrs:
  let
    versionMap =
      let
        url = "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-${finalAttrs.version}/gnat-${stdenv.hostPlatform.system}-${finalAttrs.version}.tar.gz";
      in
      {
        "13" = {
          gccVersion = "13.2.0";
          alireRevision = "2";
        }
        // {
          x86_64-darwin = {
            inherit url;
            hash = "sha256-DNHcHTIi7pw0rsVtpyGTyLVElq3IoO2YX/OkDbdeQyo=";
            upstreamTriplet = "x86_64-apple-darwin21.6.0";
          };
          x86_64-linux = {
            inherit url;
            hash = "sha256-DC95udGSzRDE22ON4UpekxTYWOSBeUdJvILbSFj6MFQ=";
            upstreamTriplet = "x86_64-pc-linux-gnu";
          };
          aarch64-darwin = {
            inherit url;
            hash = "sha256-Bjl6iuM2xLknezR92j/kpDYpxqTcxK1v8rffmivOAVw=";
            upstreamTriplet = "aarch64-apple-darwin23.2.0";
          };
        }
        .${stdenv.hostPlatform.system} or throwUnsupportedSystem;
        "14" = {
          gccVersion = "14.2.0";
          alireRevision = "1";
        }
        // {
          x86_64-darwin = {
            inherit url;
            hash = "sha256-3YOnvuI6Qq7huQcqgFSz/o+ZgY2wNkKDqHIuzNz1MVY=";
            upstreamTriplet = "x86_64-apple-darwin21.6.0";
          };
          x86_64-linux = {
            inherit url;
            hash = "sha256-pH3IuOpCM9sY/ppTYcxBmgpsUiMrisIjmAa/rmmZXb4=";
            upstreamTriplet = "x86_64-pc-linux-gnu";
          };
          aarch64-linux = {
            inherit url;
            hash = "sha256-SVW/0yyj6ZH1GAjvD+unII+zSLGd3KGFt1bjjQ3SEFU=";
            upstreamTriplet = "aarch64-linux-gnu";
          };
          aarch64-darwin = {
            inherit url;
            hash = "sha256-/nARwdQzAMd41fslUbrgloxn0hVZp9PokfQ9yPmL1g8=";
            upstreamTriplet = "aarch64-apple-darwin23.6.0";
          };
        }
        .${stdenv.hostPlatform.system} or throwUnsupportedSystem;
        "15" = {
          gccVersion = "15.2.0";
        }
        // {
          x86_64-darwin = {
            alireRevision = "1";
            inherit url;
            hash = "sha256-1YTqWsLBwNH/GBAtF5CL/YZHQvfE/3PE0LlLJ9HmjAg=";
            upstreamTriplet = "x86_64-apple-darwin22.6.0";
          };
          x86_64-linux = {
            alireRevision = "1";
            inherit url;
            hash = "sha256-b4hAg3ifoBRqgPxpfMYuOdunw7wzRTL/G5YGBO+im24=";
            upstreamTriplet = "x86_64-pc-linux-gnu";
          };
          aarch64-linux = {
            alireRevision = "1";
            inherit url;
            hash = "sha256-0V/VHqOSYQI6LmvpUIHy3zB6hI3dG0njOcDsrg8oZq8=";
            upstreamTriplet = "aarch64-linux-gnu";
          };
          aarch64-darwin = {
            alireRevision = "2-pre0";
            url = "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-15.2.0-2-macos-pre0/gnat-${stdenv.hostPlatform.system}-${finalAttrs.version}.tar.gz";
            hash = "sha256-4bFtsjixfXYc8wYOc+5iAbp1MmiIS1h1NcdKno2IdJg=";
            upstreamTriplet = "aarch64-apple-darwin24.6.0";
          };
        }
        .${stdenv.hostPlatform.system} or throwUnsupportedSystem;
        "16" = {
          gccVersion = "16.1.0";
          alireRevision = "1";
        }
        // {
          x86_64-darwin = {
            inherit url;
            hash = "sha256-u/cYFKqWLTaFADTscDxnrkYSoemKrfKpNIZ8XPlTbLI=";
            upstreamTriplet = "x86_64-apple-darwin24.6.0";
          };
          x86_64-linux = {
            inherit url;
            hash = "sha256-5bKYPJnXDGa80BtAogLE82X0zTuYKdN2cKh503oMeic=";
            upstreamTriplet = "x86_64-pc-linux-gnu";
          };
          aarch64-linux = {
            inherit url;
            hash = "sha256-jJnqDJGBOjqbT4hDW0nRpV0oA3RXxJhvI7BuvQkPDQI=";
            upstreamTriplet = "aarch64-linux-gnu";
          };
          aarch64-darwin = {
            inherit url;
            hash = "sha256-TJlV/Ngq6SwpIgGkwamTN3aRGP2BnEzJyBGovtWb6Y0=";
            upstreamTriplet = "aarch64-apple-darwin24.6.0";
          };
        }
        .${stdenv.hostPlatform.system} or throwUnsupportedSystem;
      };
    inherit (versionMap.${majorVersion}) gccVersion alireRevision upstreamTriplet;
  in
  {
    pname = "gnat-bootstrap";
    inherit (versionMap.${majorVersion}) gccVersion alireRevision;

    version = "${gccVersion}${lib.optionalString (alireRevision != "") "-"}${alireRevision}";

    src = fetchzip {
      inherit (versionMap.${majorVersion}) url hash;
    };

    nativeBuildInputs = [
      dejagnu
      gmp
      guile
      libipt
      mpfr
      python3
      readline
      sourceHighlight
      zlib
    ]
    ++ lib.optionals stdenv.buildPlatform.isLinux [
      autoPatchelfHook
      glibc
    ]
    ++ lib.optionals (lib.meta.availableOn stdenv.buildPlatform elfutils) [
      elfutils
    ];

    buildInputs = [
      expat
    ]
    ++ lib.optionals (lib.versionAtLeast majorVersion "13") [
      ncurses
    ]
    ++ lib.optionals (lib.versionOlder majorVersion "13") [
      ncurses5
    ]
    ++ [
      xz
    ]
    ++
      lib.optionals
        (
          (majorVersion == "14" && stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux)
          || (lib.versionAtLeast majorVersion "15" && stdenv.hostPlatform.isLinux)
        )
        [
          # not sure why the bootstrap binaries link to zstd only on this architecture but they do
          zstd
        ];

    __structuredAttrs = true;
    strictDeps = true;

    # https://github.com/alire-project/GNAT-FSF-builds/issues/51
    autoPatchelfIgnoreMissingDeps =
      if (stdenv.buildPlatform.isLinux && majorVersion == "13") then true else null;

    postPatch =
      lib.optionalString (stdenv.hostPlatform.isDarwin) ''
        substituteInPlace lib/gcc/${upstreamTriplet}/${gccVersion}/install-tools/mkheaders.conf \
          --replace "SYSTEM_HEADER_DIR=\"/usr/include\"" "SYSTEM_HEADER_DIR=\"/include\""
      ''
      # The included fixincl binary that is called during header fixup has a
      # hardcoded execvp("/usr/bin/sed", ...) call, but /usr/bin/sed isn't
      # available in the Nix Darwin stdenv.  Fortunately, execvp() will search the
      # PATH environment variable for the executable if its first argument does not
      # contain a slash, so we can just change the string to "sed" and zero the
      # other bytes.
      + ''
        sed -i "s,/usr/bin/sed,sed\x00\x00\x00\x00\x00\x00\x00\x00\x00," libexec/gcc/${upstreamTriplet}/${gccVersion}/install-tools/fixincl
      ''
      # Make sure that collect2 finds binutils-wrapper instead of the included ld binary.
      + ''
        rm -f bin/ld ${upstreamTriplet}/bin/ld
      '';

    installPhase = ''
      mkdir -p $out
      cp -ar * $out/
    ''

    # So far with the Darwin gnat-bootstrap binary packages, there have been two
    # types of dylib path references to other dylibs that need fixups:
    #
    # 1.  Dylibs in $out/lib with paths starting with
    #     /Users/runner/.../gcc/install that refer to other dylibs in $out/lib
    # 2.  Dylibs in $out/lib/gcc/*/*/adalib with paths starting with
    #     @rpath that refer to other dylibs in $out/lib/gcc/*/*/adalib
    #
    # Additionally, per Section 14.4 Fixed Headers in the GCC 12.2.0 manual [2],
    # we have to update the fixed header files in current Alire GCC package, since it
    # was built against macOS 10.15 (Darwin 19.6.0), but Nix currently
    # builds against macOS 10.12, and the two header file structures differ.
    # For example, the current Alire GCC package has a fixed <stdio.h>
    # from macOS 10.15 that contains a #include <_stdio.h>, but neither the Alire
    # GCC package nor macOS 10.12 have such a header (<xlocale/_stdio.h> and
    # <secure/_stdio.h> in 10.12 are not equivalent; indeed, 10.15 <_stdio.h>
    # says it contains code shared by <stdio.h> and <xlocale/_stdio.h>).
    #
    # [2]: https://gcc.gnu.org/onlinedocs/gcc-12.2.0/gcc/Fixed-Headers.html

    + lib.optionalString (stdenv.hostPlatform.isDarwin) ''
      upstreamBuildPrefix="/Users/runner/work/GNAT-FSF-builds/GNAT-FSF-builds/sbx/${stdenv.hostPlatform.system}/gcc/install"
      for i in "$out"/lib/*.dylib "$out"/lib/gcc/*/*/adalib/*.dylib; do
        if [[ -f "$i" && ! -h "$i" ]]; then
          install_name_tool -id "$i" "$i" || true
          for old_path in $(otool -L "$i" | grep "$upstreamBuildPrefix" | awk '{print $1}'); do
            new_path=`echo "$old_path" | sed "s,$upstreamBuildPrefix,$out,"`
            install_name_tool -change "$old_path" "$new_path" "$i" || true
          done
          for old_path in $(otool -L "$i" | grep "@rpath" | awk '{print $1}'); do
            new_path=$(echo "$old_path" | sed "s,@rpath,$(dirname "$i"),")
            install_name_tool -change "$old_path" "$new_path" "$i" || true
          done
        fi
      done

    ''

    # x86_64-darwin needs this for the reason above, and aarch64-linux needs it
    # to avoid https://gcc.gnu.org/bugzilla/show_bug.cgi?id=118009,
    # but x86_64-linux doesn't seem to need it.
    + lib.optionalString (stdenv.hostPlatform.system != "x86_64-linux") ''
      "$out"/libexec/gcc/${upstreamTriplet}/${gccVersion}/install-tools/mkheaders -v -v \
        "$out" "${stdenv.cc.libc}"
    '';

    passthru = {
      langC = true; # TRICK for gcc-wrapper to wrap it
      langCC = false;
      langFortran = false;
      langAda = true;
      isGNU = true;
    };

    meta = {
      description = "GNAT, the GNU Ada Translator";
      homepage = "https://www.gnu.org/software/gnat";
      license = lib.licenses.gpl3;
      maintainers = with lib.maintainers; [ ethindp ];
      platforms = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ]
      ++ lib.optionals (lib.versionAtLeast majorVersion "14") [
        "aarch64-linux"
      ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  }
)
