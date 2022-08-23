{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, pytest-xdist
, numpy
, numba
, typing-extensions
}:

buildPythonPackage rec {
  pname = "galois";
  version = "0.0.32";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mhostetter";
    repo = "galois";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-+cxRLrfqk3N9pWKCVsTxruZwMYZ5dQyKJRnrb8y+ECM=";
  };

  propagatedBuildInputs = [
    numpy
    numba
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  postPatch = ''
     substituteInPlace setup.cfg \
       --replace "numpy >= 1.18.4, < 1.23" "numpy >= 1.18.4"
    '';

  pythonImportsCheck = [ "galois" ];

  meta = {
    description = "A Python 3 package that extends NumPy arrays to operate over finite fields";
    homepage = "https://github.com/mhostetter/galois";
    downloadPage = "https://github.com/mhostetter/galois/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chrispattison ];
  };
}
