{ stdenv
, buildPythonPackage
, fetchPypi
,
}:

buildPythonPackage rec {
  pname = "pycountry";
  version = "1.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qvhq0c9xsh6d4apcvjphfzl6xnwhnk4jvhr8x2fdfnmb034lc26";
  };

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/flyingcircus/pycountry;
    description = "ISO country, subdivision, language, currency and script definitions and their translations";
    license = licenses.lgpl2;
  };

}
