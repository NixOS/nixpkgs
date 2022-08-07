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
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "ghapi";
    rev = "refs/tags/${version}";
    sha256 = "sha256-yFJ7Ek2kfFvkZwjrvvx3AXKFE4vRVsLYTSHfs+nr0Rg=";
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
