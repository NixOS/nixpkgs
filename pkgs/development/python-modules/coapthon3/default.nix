{ buildPythonPackage, cachetools, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "CoAPthon3";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w6bwwd3qjp4b4fscagqg9wqxpdgvf4sxgzbk2d2rjqwlkyr1lnx";
  };

  propagatedBuildInputs = [ cachetools ];

  meta = with lib; {
    description = "Python3 library to the CoAP protocol compliant with the RFC.";
    homepage = "https://github.com/Tanganelli/${pname}";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
