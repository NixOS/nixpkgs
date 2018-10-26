{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "process-tests";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65c9d7a0260f31c15b4a22a851757e61f7072d0557db5f8a976112fbe81ff7e9";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tools for testing processes";
    license = licenses.bsd2;
    homepage = https://github.com/ionelmc/python-process-tests;
  };

}
