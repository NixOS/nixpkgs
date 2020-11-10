{ stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "importmagic";
  version = "0.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f7757a5b74c9a291e20e12023bb3bf71bc2fa3adfb15a08570648ab83eaf8d8";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false;  # missing json file from tarball

  meta = with stdenv.lib; {
    description = "Python Import Magic - automagically add, remove and manage imports";
    homepage = "https://github.com/alecthomas/importmagic";
    license = licenses.bsd0;
  };

}
