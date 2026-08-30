{
  lib,
  buildPythonPackage,
  colorama,
  fetchPypi,
  jinja2,
  pytestCheckHook,
  pyyaml,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "mergedb";
  version = "0.1.1";
  format = "setuptools";

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

  meta = {
    description = "Tool/library for deep merging YAML files";
    mainProgram = "mergedb";
    homepage = "https://github.com/graysonhead/mergedb";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ graysonhead ];
  };
}
