{
  lib,
  buildPythonPackage,
  dill,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "multiprocess";
  version = "0.70.19";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = "multiprocess";
    tag = version;
    hash = "sha256-dH6SWecBxBQYqLohCg1gPWu6cQ7iKtRmIet9UlDMkWs=";
  };

  propagatedBuildInputs = [ dill ];

  # Python-version dependent tests
  doCheck = false;

  pythonImportsCheck = [ "multiprocess" ];

  meta = {
    description = "Multiprocessing and multithreading in Python";
    homepage = "https://github.com/uqfoundation/multiprocess";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
