{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests_oauthlib
, simplejson
}:

buildPythonPackage rec {
  pname = "pyvicare";
  version = "0.2.5";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyViCare";
    inherit version;
    sha256 = "16wqqjs238ad6znlz2gjadqj8891226bd02a1106xyz6vbbk2gdk";
  };

  propagatedBuildInputs = [
    requests_oauthlib
    simplejson
  ];

  # The published tarball on PyPI is incomplete and there are GitHub releases
  doCheck = false;
  pythonImportsCheck = [ "PyViCare" ];

  meta = with lib; {
    description = "Python Library to access Viessmann ViCare API";
    homepage = "https://github.com/somm15/PyViCare";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
