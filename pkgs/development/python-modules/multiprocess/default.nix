{
  lib,
  buildPythonPackage,
  dill,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "multiprocess";
  version = "0.70.16";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-77F5fkZbljq/tuBTkquKEYVubfghUrMZsAdhp1QpH2k=";
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
