{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "pagerduty";
  version = "0.2.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e8c237239d3ffb061069aa04fc5b3d8ae4fb0af16a9713fe0977f02261d323e9";
  };

  meta = with stdenv.lib; {
    homepage = http://github.com/samuel/python-pagerduty;
    description = "Library for the PagerDuty service API";
    license = licenses.bsd0;
  };

}
