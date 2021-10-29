{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "flashtext";
  version = "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kq5idfp9skqkjdcld40igxn2yqjly8jpmxawkp0skwxw29jpgm1";
  };

  # json files that tests look for don't exist in the pypi dist
  doCheck = false;

  meta = with lib; {
    homepage = "http://github.com/vi3k6i5/flashtext";
    description = "Python package to replace keywords in sentences or extract keywords from sentences";
    maintainers = with maintainers; [ aanderse ];
    license = with licenses; [ mit ];
  };
}
