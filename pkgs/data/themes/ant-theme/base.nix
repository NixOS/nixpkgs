{ pname, version, gitName, desc, sha256, outputHash }:
{ stdenv, fetchurl, gtk-engine-murrine }:
stdenv.mkDerivation rec {
  inherit pname version outputHash;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";

  src = fetchurl {
    url = "https://github.com/EliverLara/${gitName}/releases/download/v${version}/${gitName}.tar";
    inherit sha256;
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/${gitName}
    cp -a * $out/share/themes/${gitName}
    rm -r $out/share/themes/${gitName}/{Art,LICENSE,README.md,gtk-2.0/render-assets.sh}
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = desc;
    homepage = "https://github.com/EliverLara/${gitName}";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [
      maintainers.pbogdan
    ];
  };
}
