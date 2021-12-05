{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, six, icu }:

buildPythonPackage rec {
  pname = "PyICU";
  version = "2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d80de47045a8163db5aebc947c42b4d429eeea4f0c32af4f40b33981fa872b9";
  };

  nativeBuildInputs =
    [ icu ]; # for icu-config, but should be replaced with pkg-config
  buildInputs = [ icu ];
  checkInputs = [ pytestCheckHook six ];

  pythonImportsCheck = [ "icu" ];

  meta = with lib; {
    homepage = "https://gitlab.pyicu.org/main/pyicu";
    description = "Python extension wrapping the ICU C++ API";
    changelog = "https://gitlab.pyicu.org/main/pyicu/-/raw/v${version}/CHANGES";
    license = licenses.mit;
  };
}
