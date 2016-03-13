{ stdenv, fetchurl, pkgconfig, perl, bison, flex, python, gobjectIntrospection
, glib, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "gstreamer-1.6.1";

  meta = {
    description = "Open source multimedia framework";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer/${name}.tar.xz";
    sha256 = "172w1bpnkn6mm1wi37n03apdbb6cdkykhzjf1vfxchcd7hhkyflp";
  };

  nativeBuildInputs = [
    pkgconfig perl bison flex python gobjectIntrospection makeWrapper
  ];

  propagatedBuildInputs = [ glib ];

  postInstall = ''
    for prog in "$out/bin/"*; do
        wrapProgram "$prog" --prefix GST_PLUGIN_SYSTEM_PATH : "\$(unset _tmp; for profile in \$NIX_PROFILES; do _tmp="\$profile/lib/gstreamer-1.0''$\{_tmp:+:\}\$_tmp"; done; printf "\$_tmp")"
    done
  '';

  setupHook = ./setup-hook.sh;
}
