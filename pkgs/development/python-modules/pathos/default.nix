{
  lib,
  buildPythonPackage,
  dill,
  fetchFromGitHub,
  multiprocess,
  pox,
  ppft,
}:

buildPythonPackage rec {
  pname = "pathos";
  version = "0.3.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = "pathos";
    tag = version;
    hash = "sha256-oVqWrX40umazNw/ET/s3pKUwvh8ctgF9sS0U8WwFQkA=";
  };

  propagatedBuildInputs = [
    dill
    pox
    ppft
    multiprocess
  ];

  # Require network
  doCheck = false;

  pythonImportsCheck = [ "pathos" ];

  meta = {
    description = "Parallel graph management and execution in heterogeneous computing";
    homepage = "https://pathos.readthedocs.io/";
    changelog = "https://github.com/uqfoundation/pathos/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
