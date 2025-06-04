{
  lib,
  buildPythonPackage,
  dill,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "multiprocess";
  version = "0.70.17";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = "multiprocess";
    tag = version;
    hash = "sha256-TKD0iQv5Go4PrKWtVOF6FJG1tkvs3APxPlhDVEs7YXE=";
  };

  propagatedBuildInputs = [ dill ];

  # Python-version dependent tests
  doCheck = false;

  pythonImportsCheck = [ "multiprocess" ];

  meta = with lib; {
    description = "Multiprocessing and multithreading in Python";
    homepage = "https://github.com/uqfoundation/multiprocess";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
