{ buildDunePackage
, bigstringaf
, faraday
, fetchurl
, lib
, ke
}:

buildDunePackage rec {
  pname = "gluten";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/anmonteiro/gluten/releases/download/${version}/gluten-${version}.tbz";
    hash = "sha256-9jctX3G/nQJTGJ7ClSBEiXwxeu0GcT9N+EmPfLuSFOU=";
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [
    bigstringaf
    faraday
    ke
  ];

  doCheck = false; # No tests

  meta = {
    description = "An implementation of a platform specific runtime code for driving network libraries based on state machines, such as http/af, h2 and websocketaf";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/anmonteiro/gluten";
    maintainers = with lib.maintainers; [ anmonteiro ];
  };
}
