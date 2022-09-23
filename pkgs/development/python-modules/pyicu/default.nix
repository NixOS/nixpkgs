{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, six
, icu
}:

buildPythonPackage rec {
  pname = "PyICU";
  version = "2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PCnWzmVUYVcReho0ejA+zfzxp1ke1nn8iM3vQQiEWHg=";
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
