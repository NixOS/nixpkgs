{ lib, stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "orion";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "Orion";
    rev = "refs/tags/v${version}";
    sha256 = "1116yawv3fspkiq1ykk2wj0gza3l04b5nhldy0bayzjaj0y6fd89";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes/orion
    cp -r gtk-2.0 gtk-3.0 metacity-1 openbox-3 xfwm4 $out/share/themes/orion
  '';

  meta = {
    homepage = "https://github.com/shimmerproject/Orion";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
