{ buildDunePackage
, bigstringaf
, faraday
, fetchurl
, lib
}:

buildDunePackage rec {
  pname = "gluten";
  version = "0.2.1";

  src = fetchurl {
    url = "https://github.com/anmonteiro/gluten/releases/download/${version}/gluten-${version}.tbz";
    sha256 = "1pl0mpcprz8hmaiv28p7w51qfcx7s76zdkak0vm5cazbjl38nc46";
  };

  minimalOCamlVersion = "4.06";

  useDune2 = true;

  propagatedBuildInputs = [
    bigstringaf
    faraday
  ];

  doCheck = false; # No tests

  meta = {
    description = "An implementation of a platform specific runtime code for driving network libraries based on state machines, such as http/af, h2 and websocketaf";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/anmonteiro/gluten";
    maintainers = with lib.maintainers; [ anmonteiro ];
  };
}
