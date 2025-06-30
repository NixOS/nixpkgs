{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "json2html";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "softvar";
    repo = "json2html";
    rev = "v${version}";
    hash = "sha256-Y+mwJ0p4Q2TKMU8qQvuvo08RiMdsReO7psgXaiW9ntk=";
  };

  build-system = [ setuptools ];

  # no proper test available
  doCheck = false;

  pythonImportsCheck = [ "json2html" ];

  meta = {
    description = "Python module for converting complex JSON to HTML Table representation";
    homepage = "https://github.com/softvar/json2html";
    changelog = "https://github.com/softvar/json2html/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
  };
}
