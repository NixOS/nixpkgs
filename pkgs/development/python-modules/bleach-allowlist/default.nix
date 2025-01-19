{
  lib,
  buildPythonPackage,
  fetchPypi,
  bleach,
}:

buildPythonPackage rec {
  pname = "bleach-allowlist";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VuIghgeaDmoxAK6Z5NuvIOslhUhlmOsOmUAIoRQo2ps=";
  };

  propagatedBuildInputs = [ bleach ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "bleach_allowlist" ];

  meta = {
    description = "Curated lists of tags and attributes for sanitizing html";
    homepage = "https://github.com/yourcelf/bleach-allowlist";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
