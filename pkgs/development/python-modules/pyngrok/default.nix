{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pyyaml
}:

buildPythonPackage rec {
  pname = "pyngrok";
  version = "7.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wTK0DnsZBbB9nHMe8hUQjMl3sbv0RaFGiU4NSJshPrY=";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  pythonImportsCheck = [ "pyngrok" ];

  meta = with lib; {
    description = "A Python wrapper for ngrok";
    homepage = "https://github.com/alexdlaird/pyngrok";
    changelog = "https://github.com/alexdlaird/pyngrok/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
