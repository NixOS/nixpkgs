{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, six
, icu
}:

buildPythonPackage rec {
  pname = "pyicu";
  version = "2.11";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyICU";
    inherit version;
    hash = "sha256-OrUxJkz+kTKz0qxdcI2ppGSdJfbmgTcwrIjPBAoIqEQ=";
  };

  nativeBuildInputs = [ icu ]; # for icu-config, but should be replaced with pkg-config
  buildInputs = [ icu ];
  nativeCheckInputs = [ pytestCheckHook six ];

  pythonImportsCheck = [ "icu" ];

  meta = with lib; {
    homepage = "https://gitlab.pyicu.org/main/pyicu";
    description = "Python extension wrapping the ICU C++ API";
    changelog = "https://gitlab.pyicu.org/main/pyicu/-/raw/v${version}/CHANGES";
    license = licenses.mit;
  };
}
