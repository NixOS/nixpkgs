{ lib, stdenv, fetchurl, gtk-engine-murrine }:

let
  themeName = "Ant";
in
stdenv.mkDerivation rec {
  pname = "ant-theme";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/EliverLara/${themeName}/releases/download/v${version}/${themeName}.tar";
    sha256 = "1r795v96ywzcb4dq08q2fdbmfia32g36cc512mhy41s8fb1a47dz";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/${themeName}
    cp -a * $out/share/themes/${themeName}
    rm -r $out/share/themes/${themeName}/{Art,LICENSE,README.md,gtk-2.0/render-assets.sh}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Flat and light theme with a modern look";
    homepage = "https://github.com/EliverLara/${themeName}";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ alexarice ];
  };
}
