{ lib, buildPythonPackage, fetchPypi, dill }:

buildPythonPackage rec {
  pname = "multiprocess";
  version = "0.70.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "46479a327388df8e77ad268892f2e73eac06d6271189b868ce9d4f95474e58e3";
  };

  propagatedBuildInputs = [ dill ];

  # Python-version dependent tests
  doCheck = false;

  meta = with lib; {
    description = "Better multiprocessing and multithreading in python";
    homepage = https://github.com/uqfoundation/multiprocess;
    license = licenses.bsd3;
  };
}
