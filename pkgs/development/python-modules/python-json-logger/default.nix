{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-json-logger";
  version = "2.0.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I+fsAtNCN8WqHimgcBk6Tqh1g7tOf4/QbT3oJkxLLhw=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Json Formatter for the standard python logger";
    homepage = "https://github.com/madzak/python-json-logger";
    license = licenses.bsdOriginal;
    maintainers = [ ];
  };
}
