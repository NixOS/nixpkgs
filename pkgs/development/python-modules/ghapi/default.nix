{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fastcore,
  packaging,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ghapi";
  version = "1.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "ghapi";
    rev = "refs/tags/${version}";
    hash = "sha256-ii19wuFAxMiGce37TNXRNSdvMcGWQjCfPukeqxySYnc=";
  };

  propagatedBuildInputs = [
    fastcore
    packaging
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ghapi" ];

  meta = with lib; {
    description = "Python interface to GitHub's API";
    homepage = "https://github.com/fastai/ghapi";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
