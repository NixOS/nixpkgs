{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pycrypto
}:

buildPythonPackage rec {
  pname = "http_signature";
  version = "0.1.4";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "14acc192ef20459d5e11b4e800dd3a4542f6bd2ab191bf5717c696bf30936c62";
  };

  propagatedBuildInputs = [ pycrypto ];

  meta = with lib; {
    homepage = "https://github.com/atl/py-http-signature";
    description = "Simple secure signing for HTTP requests using http-signature";
    license = licenses.mit;
  };

}
