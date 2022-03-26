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
  version = "0.10.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "376e50f4e70a1ae935416ddfcf93db35dd5d4cc0e557f2ec72f0667d0ace4548";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
