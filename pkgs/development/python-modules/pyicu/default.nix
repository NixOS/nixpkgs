{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, six
, icu
}:

buildPythonPackage rec {
  pname = "PyICU";
  version = "2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wb3v421i2fnnxdywam4ay8hqvnxlz0r2nrpx5lqy3rn6dlbz9d9";
  };

  nativeBuildInputs = [ icu ]; # for icu-config
  buildInputs = [ icu ];
  checkInputs = [ pytestCheckHook six ];

  meta = with lib; {
    homepage = "https://github.com/ovalhub/pyicu/";
    description = "Python extension wrapping the ICU C++ API";
    license = licenses.mit;
    platforms = platforms.unix;
  };

}
