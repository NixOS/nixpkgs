{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  regex,
}:

buildPythonPackage rec {
  pname = "rebulk";
  version = "3.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DTC/gPygD6nGlxhaxHXarJveX2Rs4zOMn/XV3B69/rw=";
  };

  propagatedBuildInputs = [ regex ];

  buildInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rebulk" ];

  meta = with lib; {
    description = "Advanced string matching from simple patterns";
    homepage = "https://github.com/Toilal/rebulk/";
    changelog = "https://github.com/Toilal/rebulk/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
