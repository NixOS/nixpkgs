{ lib
, buildPythonPackage
, fetchPypi
, ordered-set
, quantities
, matplotlib
, texlive
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "PyLaTeX";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb7b21bec57ecdba3f6f44c856ebebdf6549fd6e80661bd44fd5094236729242";
  };

  propagatedBuildInputs = [
    ordered-set
    quantities
  ];

  checkInputs = [
    matplotlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
    texlive.combined.scheme-full
  ];

  # One test doesn't work because a file is missing from the PyPI tarball. See:
  # https://github.com/JelteF/PyLaTeX/pull/379
  disabledTestPaths = [
    "tests/test_pictures.py"
  ];

  meta = with lib; {
    description = "Python library for creating and compiling LaTeX files or snippets";
    homepage = "https://github.com/JelteF/PyLaTeX";
    downloadPage = "https://pypi.org/project/PyLaTeX/#files";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
