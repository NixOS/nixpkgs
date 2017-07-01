{ lib
, buildPythonPackage
, fetchurl
, bottle
, isPy3k
}:

buildPythonPackage rec {
  pname = "grammalecte";
  version = "0.5.17";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.dicollecte.org/grammalecte/oxt/Grammalecte-fr-v${version}.zip";
    sha256 = "0ccvj8p8bwvrj8bp370dzjs16pwm755a7364lvk8bp4505n7g0b6";
  };

  propagatedBuildInputs = [ bottle ];

  preBuild = "cd ..";
  postInstall = ''
    mkdir $out/bin
    cp $out/cli.py $out/bin/gramalecte
    cp $out/server.py $out/bin/gramalected
    chmod a+rx $out/bin/gramalecte
    chmod a+rx $out/bin/gramalected
  '';

  disabled = !isPy3k;

  meta = {
    description = "Grammalecte is an open source grammar checker for the French language";
    homepage = "https://dicollecte.org/grammalecte/";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ apeyroux ];
  };
}