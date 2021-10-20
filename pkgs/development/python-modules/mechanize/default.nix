{ lib
, buildPythonPackage
, fetchPypi
, html5lib
}:

buildPythonPackage rec {
  pname = "mechanize";
  version = "0.4.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1773a8f5818398e0010e781dc0f942cd88b107a57424c904d545cd827c216809";
  };

  propagatedBuildInputs = [ html5lib ];

  doCheck = false;

  meta = with lib; {
    description = "Stateful programmatic web browsing in Python";
    homepage = "https://github.com/python-mechanize/mechanize";
    license = "BSD-style";
  };

}
