{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, six
, icu68
}:

buildPythonPackage rec {
  pname = "PyICU";
  version = "2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d80de47045a8163db5aebc947c42b4d429eeea4f0c32af4f40b33981fa872b9";
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
