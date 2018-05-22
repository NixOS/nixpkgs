{ stdenv, fetchurl, fetchpatch, meson, ninja
, pkgconfig, gettext, gobjectIntrospection
, bison, flex, python3, glib, makeWrapper
, libcap,libunwind, darwin
, lib
}:

stdenv.mkDerivation rec {
  name = "gstreamer-1.14.0";

  meta = with lib ;{
    description = "Open source multimedia framework";
    homepage = https://gstreamer.freedesktop.org;
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ttuegel matthewbauer ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer/${name}.tar.xz";
    sha256 = "0vj6k01lp2yva6rfd95fkyng9jdr62gkz0x8d2l81dyly1ki6dpw";
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
    meson ninja pkgconfig gettext bison flex python3 makeWrapper gobjectIntrospection
  ];
  buildInputs =
       lib.optionals stdenv.isLinux [ libcap libunwind ]
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.CoreServices;

  propagatedBuildInputs = [ glib ];

  postInstall = ''
    for prog in "$dev/bin/"*; do
        wrapProgram "$prog" --suffix GST_PLUGIN_SYSTEM_PATH : "\$(unset _tmp; for profile in \$NIX_PROFILES; do _tmp="\$profile/lib/gstreamer-1.0''$\{_tmp:+:\}\$_tmp"; done; printf "\$_tmp")"
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
