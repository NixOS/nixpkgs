{ lib, buildPythonPackage, fetchPypi
, django, dateutil, whoosh, pysolr, elasticsearch
, coverage, mock, nose, geopy }:

buildPythonPackage rec {
  pname = "django-haystack";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04cva8qg79xig4zqhb4dwkpm7734dvhzqclzvrdz70fh59ki5b4f";
  };

  doCheck = false;  # no tests in source

  checkInputs = [ elasticsearch pysolr whoosh dateutil geopy coverage nose mock coverage ];
  propagatedBuildInputs = [ django ];

  patchPhase = ''
    sed -i 's/geopy==/geopy>=/' setup.py
    sed -i 's/whoosh==/Whoosh>=/' setup.py
  '';

  meta = with lib; {
    description = "Modular search for Django";
    homepage = "http://haystacksearch.org/";
    license = licenses.bsd3;
  };
}
