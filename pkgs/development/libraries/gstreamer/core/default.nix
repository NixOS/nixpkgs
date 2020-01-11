{ stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkgconfig
, gettext
, gobject-introspection
, bison
, flex
, python3
, glib
, makeWrapper
, libcap
, libunwind
, darwin
, elfutils # for libdw
, bash-completion
, docbook_xsl
, docbook_xml_dtd_43
, gtk-doc
, lib
, CoreServices
}:

stdenv.mkDerivation rec {
  pname = "gstreamer";
  version = "1.16.2";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0kp93622y29pck8asvil1fmzf55s2gx76wv475a6izc3cwj49w73";
  };

  patches = [
    ./fix_pkgconfig_includedir.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    bison
    flex
    python3
    makeWrapper
    gobject-introspection
    bash-completion

    # documentation
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    libcap
    libunwind
    elfutils
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Ddbghelp=disabled" # not needed as we already provide libunwind and libdw, and dbghelp is a fallback to those
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
  ] ++ lib.optionals stdenv.isDarwin [
    # darwin.libunwind doesn't have pkgconfig definitions so meson doesn't detect it.
    "-Dlibunwind=disabled"
    "-Dlibdw=disabled"
  ];

  postPatch = ''
    patchShebangs \
      gst/parse/get_flex_version.py \
      gst/parse/gen_grammar.py.in \
      gst/parse/gen_lex.py.in \
      libs/gst/helpers/ptp_helper_post_install.sh
  '';

  postInstall = ''
    for prog in "$dev/bin/"*; do
        # We can't use --suffix here due to quoting so we craft the export command by hand
        wrapProgram "$prog" --run "export GST_PLUGIN_SYSTEM_PATH=\$GST_PLUGIN_SYSTEM_PATH"$\{GST_PLUGIN_SYSTEM_PATH:+:\}"\$(unset _tmp; for profile in \$NIX_PROFILES; do _tmp="\$profile/lib/gstreamer-1.0''$\{_tmp:+:\}\$_tmp"; done; printf "\$_tmp")"
    done
  '';

  preFixup = ''
    moveToOutput "share/bash-completion" "$dev"
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib ;{
    description = "Open source multimedia framework";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ttuegel matthewbauer ];
  };
}
