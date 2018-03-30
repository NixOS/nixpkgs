{ stdenv, fetchurl, pkgconfig, perl, bison, flex, python, gobjectIntrospection
, glib, makeWrapper
, darwin
}:

stdenv.mkDerivation rec {
  name = "gstreamer-1.14.0";

  meta = {
    description = "Open source multimedia framework";
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer/${name}.tar.xz";
    sha256 = "0vj6k01lp2yva6rfd95fkyng9jdr62gkz0x8d2l81dyly1ki6dpw";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  nativeBuildInputs = [
    pkgconfig perl bison flex python gobjectIntrospection makeWrapper
  ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.CoreServices;

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
