{ stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "ant-theme";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/EliverLara/Ant/releases/download/v${version}/Ant.tar";
    sha256 = "1r795v96ywzcb4dq08q2fdbmfia32g36cc512mhy41s8fb1a47dz";
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
  outputHash = "1gpacrmi5y87shp39jgy78n0ca2xdpvbqfh0mgldlxx99ca9rvvy";

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
