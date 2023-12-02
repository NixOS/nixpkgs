{ stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gettext
, bison
, flex
, python3
, glib
, makeWrapper
, libcap
, libunwind
, elfutils # for libdw
, bash-completion
, lib
, Cocoa
, CoreServices
, gobject-introspection
, testers
# Checks meson.is_cross_build(), so even canExecute isn't enough.
, enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform, hotdoc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gstreamer";
  version = "1.22.5";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  src = let
    inherit (finalAttrs) pname version;
  in fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-RAjXkw84GAnoWReswZcS8XMmG6hb3yDFVnsqIbEZO2E=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    bison
    flex
    python3
    makeWrapper
    glib
    bash-completion
    gobject-introspection
  ] ++ lib.optionals stdenv.isLinux [
    libcap # for setcap binary
  ] ++ lib.optionals enableDocumentation [
    hotdoc
  ];

  buildInputs = [
    bash-completion
  ] ++ lib.optionals stdenv.isLinux [
    libcap
    libunwind
    elfutils
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
    CoreServices
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Ddbghelp=disabled" # not needed as we already provide libunwind and libdw, and dbghelp is a fallback to those
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    (lib.mesonEnable "doc" enableDocumentation)
  ] ++ lib.optionals stdenv.isDarwin [
    # darwin.libunwind doesn't have pkg-config definitions so meson doesn't detect it.
    "-Dlibunwind=disabled"
    "-Dlibdw=disabled"
  ];

  postPatch = ''
    patchShebangs \
      gst/parse/get_flex_version.py \
      gst/parse/gen_grammar.py.in \
      gst/parse/gen_lex.py.in \
      libs/gst/helpers/ptp_helper_post_install.sh \
      scripts/extract-release-date-from-doap-file.py
  '';

  postInstall = ''
    for prog in "$bin/bin/"*; do
        # We can't use --suffix here due to quoting so we craft the export command by hand
        wrapProgram "$prog" --run 'export GST_PLUGIN_SYSTEM_PATH_1_0=$GST_PLUGIN_SYSTEM_PATH_1_0''${GST_PLUGIN_SYSTEM_PATH_1_0:+:}$(unset _tmp; for profile in $NIX_PROFILES; do _tmp="$profile/lib/gstreamer-1.0''${_tmp:+:}$_tmp"; done; printf '%s' "$_tmp")'
    done
  '';

  preFixup = ''
    moveToOutput "share/bash-completion" "$bin"
  '';

  setupHook = ./setup-hook.sh;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Open source multimedia framework";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    pkgConfigModules = [
      "gstreamer-controller-1.0"
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ ttuegel matthewbauer lilyinstarlight ];
  };
})
