{ stdenv
, buildPythonPackage
, fetchPypi
,
}:

buildPythonPackage rec {
  pname = "pycountry";
  version = "19.8.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jxkdjffrhn0il0nm14dlzxpd6f3v1hbxzxsprcksafgmm0almrw";
  };

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/flyingcircus/pycountry;
    description = "ISO country, subdivision, language, currency and script definitions and their translations";
    license = licenses.lgpl2;
  };

}
