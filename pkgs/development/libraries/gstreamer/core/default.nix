{ stdenv, fetchurl, fetchpatch, meson, ninja
, pkgconfig, gettext, gobject-introspection
, bison, flex, python3, glib, makeWrapper
, libcap,libunwind, darwin
, lib
}:

stdenv.mkDerivation rec {
  name = "gstreamer-${version}";
  version = "1.14.4";

  meta = with lib ;{
    description = "Open source multimedia framework";
    homepage = https://gstreamer.freedesktop.org;
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ttuegel matthewbauer ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer/${name}.tar.xz";
    sha256 = "1izzhnlsy83rgr4zl3jcl1sryxqbbigrrqw3j4x3nnphqnb6ckzr";
  };

  patches = [
    (fetchpatch {
        url = "https://bug794856.bugzilla-attachments.gnome.org/attachment.cgi?id=370411";
        sha256 = "16plzzmkk906k4892zq68j3c9z8vdma5nxzlviq20jfv04ykhmk2";
    })
    ./fix_pkgconfig_includedir.patch
  ];

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  nativeBuildInputs = [
    meson ninja pkgconfig gettext bison flex python3 makeWrapper gobject-introspection
  ];
  buildInputs =
       lib.optionals stdenv.isLinux [ libcap libunwind ]
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.CoreServices;

  propagatedBuildInputs = [ glib ];

  postInstall = ''
    for prog in "$dev/bin/"*; do
        # We can't use --suffix here due to quoting so we craft the export command by hand
        wrapProgram "$prog" --run "export GST_PLUGIN_SYSTEM_PATH=\$GST_PLUGIN_SYSTEM_PATH"$\{GST_PLUGIN_SYSTEM_PATH:+:\}"\$(unset _tmp; for profile in \$NIX_PROFILES; do _tmp="\$profile/lib/gstreamer-1.0''$\{_tmp:+:\}\$_tmp"; done; printf "\$_tmp")"
    done
  '';

  preConfigure= ''
    patchShebangs .
  '';

  preFixup = ''
    moveToOutput "share/bash-completion" "$dev"
  '';

  setupHook = ./setup-hook.sh;
}
