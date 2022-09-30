{ lib
, buildPythonPackage
, setuptools-scm
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
  version = "0.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mhostetter";
    repo = "galois";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ekbebwsdGkINdOFI+LLdwTRBN6d8mlNmftkj5SNRKNI=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

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
     substituteInPlace pyproject.toml \
       --replace "numpy >= 1.18.4, < 1.24" "numpy >= 1.18.4" \
       --replace "numba >= 0.53, < 0.57" "numba >= 0.53" \
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
