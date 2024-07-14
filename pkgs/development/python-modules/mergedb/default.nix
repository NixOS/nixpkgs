{
  lib,
  buildPythonPackage,
  colorama,
  fetchPypi,
  jinja2,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "mergedb";
  version = "0.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IDTBjcojRWxbFmtj2UMAvNjsnzhubNY5wvZuFBwDE/k=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    pyyaml
    colorama
    jinja2
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mergedb" ];

  meta = with lib; {
    description = "Tool/library for deep merging YAML files";
    mainProgram = "mergedb";
    homepage = "https://github.com/graysonhead/mergedb";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ graysonhead ];
  };
}
