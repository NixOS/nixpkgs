{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, six
, icu
}:

buildPythonPackage rec {
  pname = "PyICU";
  version = "2.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8LlUmof4e6fEE/E2edE3Jx4LN/HzmwEJrOOCV9TRSNY=";
  };

  nativeBuildInputs = [ icu ]; # for icu-config, but should be replaced with pkg-config
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
