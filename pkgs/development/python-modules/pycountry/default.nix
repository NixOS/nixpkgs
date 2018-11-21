{ stdenv
, buildPythonPackage
, fetchPypi
,
}:

buildPythonPackage rec {
  pname = "pycountry";
  version = "18.5.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15q9j047s3yc9cfcxq1ch8b71f81na44cr6dydd5gxk0ki9a4akz";
  };

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/flyingcircus/pycountry;
    description = "ISO country, subdivision, language, currency and script definitions and their translations";
    license = licenses.lgpl2;
  };

}
