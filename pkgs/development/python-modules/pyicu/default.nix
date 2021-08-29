{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, six
, icu68
}:

buildPythonPackage rec {
  pname = "PyICU";
  version = "2.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jv1pds94agvn3zs33a8p8f0mk7f5pjwmczmg1s05ri5p0kzk4h8";
  };

  nativeBuildInputs = [ icu68 ]; # for icu-config, but should be replaced with pkg-config
  buildInputs = [ icu68 ];
  checkInputs = [ pytestCheckHook six ];

  meta = with lib; {
    homepage = "https://github.com/ovalhub/pyicu/";
    description = "Python extension wrapping the ICU C++ API";
    license = licenses.mit;
    platforms = platforms.unix;
  };

}
