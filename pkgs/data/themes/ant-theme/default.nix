{ stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "ant-theme";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/EliverLara/Ant/releases/download/v${version}/Ant.tar";
    sha256 = "15751pnb94g2wi6y932l3d7ksaz18402zbzp3l7ryy0lqwjnqvkj";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/Ant
    cp -a * $out/share/themes/Ant
    rm -r $out/share/themes/Ant/{Art,LICENSE,README.md,gtk-2.0/render-assets.sh}
    runHook postInstall
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1fzy7bq5v9fzjpfxplvk0nwjgamcva83462gkz01lhr1mipb92h1";

  meta = with stdenv.lib; {
    description = "A flat and light theme with a modern look";
    homepage = https://github.com/EliverLara/Ant;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [
      maintainers.pbogdan
    ];
  };
}
