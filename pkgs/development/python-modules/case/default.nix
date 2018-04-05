{ stdenv, buildPythonPackage, fetchPypi
, six, nose, unittest2, mock }:

buildPythonPackage rec {
  pname = "case";
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zbhbw87izcxj9rvqg432a7r69ps2ks20mqq3g3hgd42sckcy3ca";
  };

  propagatedBuildInputs = [ six nose unittest2 mock ];

  meta = with stdenv.lib; {
    homepage = https://github.com/celery/case;
    description = "unittests utilities";
    license = licenses.bsd3;
  };
}
