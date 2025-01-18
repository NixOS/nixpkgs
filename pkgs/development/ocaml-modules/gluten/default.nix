{
  buildDunePackage,
  bigstringaf,
  faraday,
  fetchurl,
  lib,
}:

buildDunePackage rec {
  pname = "gluten";
  version = "0.5.2";

  src = fetchurl {
    url = "https://github.com/anmonteiro/gluten/releases/download/${version}/gluten-${version}.tbz";
    hash = "sha256-se7Yn59ggLtL0onMjSUsa88B8D05Vybmb6YGcgfnAV8=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    bigstringaf
    faraday
  ];

  doCheck = false; # No tests

  meta = with lib; {
    description = "Implementation of a platform specific runtime code for driving network libraries based on state machines, such as http/af, h2 and websocketaf";
    license = licenses.bsd3;
    homepage = "https://github.com/anmonteiro/gluten";
    maintainers = with maintainers; [ anmonteiro ];
  };
}
