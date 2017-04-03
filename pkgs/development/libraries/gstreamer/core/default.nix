{ stdenv, fetchurl, pkgconfig, perl, bison, flex, python, gobjectIntrospection
, glib, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "gstreamer-1.10.4";

  meta = {
    description = "Open source multimedia framework";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer/${name}.tar.xz";
    sha256 = "062jidnw17hkpva6ddygp80gyasyigfkpm1y7w56rk56a2pzbhjh";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  nativeBuildInputs = [
    pkgconfig perl bison flex python gobjectIntrospection makeWrapper
  ];

  propagatedBuildInputs = [ glib ];

  enableParallelBuilding = true;

  preConfigure = ''
    configureFlagsArray+=("--exec-prefix=$dev")
  '';

  postInstall = ''
    for prog in "$dev/bin/"*; do
        wrapProgram "$prog" --suffix GST_PLUGIN_SYSTEM_PATH : "\$(unset _tmp; for profile in \$NIX_PROFILES; do _tmp="\$profile/lib/gstreamer-1.0''$\{_tmp:+:\}\$_tmp"; done; printf "\$_tmp")"
    done
  '';

  preFixup = ''
    moveToOutput "share/bash-completion" "$dev"
  '';

  setupHook = ./setup-hook.sh;
}
