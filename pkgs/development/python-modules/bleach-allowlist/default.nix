{ lib
, buildPythonPackage
, fetchPypi
, bleach
}:

buildPythonPackage rec {
  pname = "bleach-allowlist";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VuIghgeaDmoxAK6Z5NuvIOslhUhlmOsOmUAIoRQo2ps=";
  };

  propagatedBuildInputs = [
    bleach
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "bleach_allowlist" ];

  meta = with lib; {
    description = "Curated lists of tags and attributes for sanitizing html";
    homepage = "https://github.com/yourcelf/bleach-allowlist";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ambroisie ];
  };
}
