{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "logutils";
  version = "0.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc058a25d5c209461f134e1f03cab637d66a7a5ccc12e593db56fbb279899a82";
  };

  meta = with stdenv.lib; {
    description = "Logging utilities";
    homepage = "https://bitbucket.org/vinay.sajip/logutils/";
    license = licenses.bsd0;
  };

}
