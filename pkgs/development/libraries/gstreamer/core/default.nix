{ stdenv, fetchurl, fetchpatch, meson, ninja
, pkgconfig, gettext, gobject-introspection
, bison, flex, python3, glib, makeWrapper
, libcap,libunwind, darwin
, elfutils # for libdw
, bash-completion
, docbook_xsl, docbook_xml_dtd_412
, gtk-doc
, lib
, CoreServices
}:

stdenv.mkDerivation rec {
  pname = "gstreamer";
  version = "1.16.0";

  meta = with lib ;{
    description = "Open source multimedia framework";
    homepage = https://gstreamer.freedesktop.org;
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ttuegel matthewbauer ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer/${pname}-${version}.tar.xz";
    sha256 = "003wy1p1in85p9sr5jsyhbnwqaiwz069flwkhyx7qhxy31qjz3hf";
  };

  patches = [
    ./fix_pkgconfig_includedir.patch
  ];

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  nativeBuildInputs = [
    meson ninja pkgconfig gettext bison flex python3 makeWrapper gobject-introspection
    bash-completion
    gtk-doc
    # Without these, enabling the 'gtk_doc' gives us `FAILED: meson-install`
    docbook_xsl docbook_xml_dtd_412
  ];

  buildInputs =
       lib.optionals stdenv.isLinux [ libcap libunwind elfutils ]
    ++ lib.optional stdenv.isDarwin CoreServices;

  propagatedBuildInputs = [ glib ];

  mesonFlags = [
    # Enables all features, so that we know when new dependencies are necessary.
    "-Dauto_features=enabled"
    "-Ddbghelp=disabled" # not needed as we already provide libunwind and libdw, and dbghelp is a fallback to those
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
  ]
    # darwin.libunwind doesn't have pkgconfig definitions so meson doesn't detect it.
    ++ stdenv.lib.optionals stdenv.isDarwin [ "-Dlibunwind=disabled" "-Dlibdw=disabled" ];

  postInstall = ''
    for prog in "$dev/bin/"*; do
        # We can't use --suffix here due to quoting so we craft the export command by hand
        wrapProgram "$prog" --run "export GST_PLUGIN_SYSTEM_PATH=\$GST_PLUGIN_SYSTEM_PATH"$\{GST_PLUGIN_SYSTEM_PATH:+:\}"\$(unset _tmp; for profile in \$NIX_PROFILES; do _tmp="\$profile/lib/gstreamer-1.0''$\{_tmp:+:\}\$_tmp"; done; printf "\$_tmp")"
    done
  '';

  preConfigure=
    # These files are not executable upstream, so we need to
    # make them executable for `patchShebangs` to pick them up.
    # Can be removed when this is merged and available:
    #     https://gitlab.freedesktop.org/gstreamer/gstreamer/merge_requests/141
    ''
      chmod +x gst/parse/get_flex_version.py
    '' +
    ''
      patchShebangs .
    '';

  preFixup = ''
    moveToOutput "share/bash-completion" "$dev"
  '';

  setupHook = ./setup-hook.sh;
}
