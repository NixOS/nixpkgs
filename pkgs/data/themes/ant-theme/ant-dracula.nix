{ stdenv, fetchurl, gtk-engine-murrine }:

let
  themeName = "Ant-Dracula";
in
stdenv.mkDerivation rec {
  pname = "ant-dracula-theme";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/EliverLara/${themeName}/releases/download/v${version}/${themeName}.tar";
    sha256 = "00b8w69xapqy8kc7zqwlfz1xpld6hibbh35djvhcnd905gzzymkd";
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
  outputHash = "1a9mkxfb0zixx8s05h15lhnnzygh2qzc8k2q10i0khx90bf72x14";

  meta = with stdenv.lib; {
    description = "Dracula variant of the Ant theme";
    homepage = "https://github.com/EliverLara/${themeName}";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ alexarice ];
  };
}
