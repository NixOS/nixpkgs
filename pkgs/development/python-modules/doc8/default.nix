{ lib
, buildPythonPackage
, chardet
, docutils
, fetchPypi
, pbr
, pygments
, pytestCheckHook
, pythonOlder
, restructuredtext_lint
, setuptools-scm
, stevedore
}:

buildPythonPackage rec {
  pname = "doc8";
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2XqT6PWi78RxOggEZX3trYN0XMpM0diN6Rhvd/l3YAQ=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    docutils
    chardet
    stevedore
    restructuredtext_lint
    pygments
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "doc8"
  ];

  meta = with lib; {
    description = "Style checker for Sphinx (or other) RST documentation";
    homepage = "https://github.com/pycqa/doc8";
    changelog = "https://github.com/PyCQA/doc8/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
