{ lib
, buildPythonPackage
, fetchFromPyPI
,
}:

buildPythonPackage rec {
  pname = "pycountry";
  version = "20.7.3";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "0hnbabsmqimx5hqh0jbd2f64i8fhzhhbrvid57048hs5sd9ll241";
  };

  meta = with lib; {
    homepage = "https://bitbucket.org/flyingcircus/pycountry";
    description = "ISO country, subdivision, language, currency and script definitions and their translations";
    license = licenses.lgpl2;
  };

}
