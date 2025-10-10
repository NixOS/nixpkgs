{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
  bracex,
}:

buildPythonPackage rec {
  pname = "wcmatch";
  version = "10.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8R+UIIyMhIShb09IY4qF13HZUT9Ks/N1lZeIAcuUZa8=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ bracex ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [ "TestTilde" ];

  pythonImportsCheck = [ "wcmatch" ];

  meta = with lib; {
    description = "Wilcard File Name matching library";
    homepage = "https://github.com/facelessuser/wcmatch";
    license = licenses.mit;
    maintainers = [ ];
  };
}
