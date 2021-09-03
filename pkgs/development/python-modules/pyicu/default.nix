{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, six
, icu68
}:

buildPythonPackage rec {
  pname = "PyICU";
  version = "2.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0655302e2aea16f9acefe04152f74e5d7d70542e9e15c89ee8d763c8e097f56";
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
