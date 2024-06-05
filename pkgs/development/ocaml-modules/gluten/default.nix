{ buildDunePackage
, bigstringaf
, faraday
, fetchurl
, lib
}:

buildDunePackage rec {
  pname = "gluten";
  version = "0.5.1";

  src = fetchurl {
    url = "https://github.com/anmonteiro/gluten/releases/download/${version}/gluten-${version}.tbz";
    hash = "sha256-VZcbMFDRv+TVSXG05wUYxaWbTnBSa43RiVx9OesPnZY=";
  };

  minimalOCamlVersion = "4.08";

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
