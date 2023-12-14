{ lib, stdenv, buildPythonPackage, pythonOlder, fetchPypi, setuptools
, pytestCheckHook, poetry-core, retrying, urllib3, certifi, alpha-vantage }:

buildPythonPackage rec {
  pname = "intrinio-sdk";
  version = "6.26.3";
  pyproject = true;

  disabled = pythonOlder "3.10";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HhAQDelKi3wD4JreanP7BQw7siOGV3i6vEPg9KD3r+U=";
  };

  nativeBuildInputs = [ setuptools poetry-core ];

  propagatedBuildInputs = [ retrying urllib3 certifi alpha-vantage ];

  nativeCheckinputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "intrinio_sdk" ];

  meta = with lib; {
    changelog =
      "https://github.com/intrinio/python-sdk/releases/tag/${version}";
    description = "The Official Intrinio API Python SDK";
    homepage = "https://github.com/intrinio/python-sdk";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
