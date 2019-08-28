{ stdenv, fetchurl, gtk-engine-murrine }:

let
  themeName = "Ant-Bloody";
in
stdenv.mkDerivation rec {
  pname = "ant-bloody-theme";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/EliverLara/${themeName}/releases/download/v${version}/${themeName}.tar";
    sha256 = "0rrz50kmzjmqj17hvrw67pbaclwxv85i5m08s7842iky6dnn5z8s";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/${themeName}
    cp -a * $out/share/themes/${themeName}
    rm -r $out/share/themes/${themeName}/{Art,LICENSE,README.md,gtk-2.0/render-assets.sh}
    runHook postInstall
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0v5pdhysa2460sh400cpq11smcfsi9g1lbfzx8nj1w5a21d811cz";

  meta = with stdenv.lib; {
    description = "Bloody variant of the Ant theme";
    homepage = "https://github.com/EliverLara/${themeName}";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ alexarice ];
  };
}
