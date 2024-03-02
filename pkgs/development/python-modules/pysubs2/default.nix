{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "pysubs2";
  version = "1.6.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tkarabela";
    repo = pname;
    rev =  version;
    hash = "sha256-0bW9aB6ERRQK3psqeU0Siyi/8drEGisAp8UtTfOKlp0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pysubs2"
  ];

  meta = with lib; {
    homepage = "https://github.com/tkarabela/pysubs2";
    description = "A Python library for editing subtitle files";
    license = licenses.mit;
    maintainers = with maintainers; [ Benjamin-L ];
  };
}
