{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, fastcore
, packaging
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ghapi";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "ghapi";
    rev = "refs/tags/${version}";
    sha256 = "sha256-BbgI9SS5NqYCbcT3F+jximVILF2LlyeQyEdR84L6JIc=";
  };

  propagatedBuildInputs = [
    fastcore
    packaging
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ghapi"
  ];

  meta = with lib; {
    description = "Python interface to GitHub's API";
    homepage = "https://github.com/fastai/ghapi";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
