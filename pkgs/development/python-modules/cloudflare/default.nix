{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, requests
, pyyaml
, jsonlines
, pythonOlder
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "cloudflare";
  version = "2.18.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F8eNXUUEsTG/Qas9+UzmAtJaHrLxst9kQZV2C3LmTD8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    requests
    pyyaml
    jsonlines
  ];

  # tests require networking
  doCheck = false;

  pythonImportsCheck = [
    "CloudFlare"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ];

  meta = with lib; {
    description = "Python wrapper for the Cloudflare v4 API";
    homepage = "https://github.com/cloudflare/python-cloudflare";
    changelog = "https://github.com/cloudflare/python-cloudflare/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "cli4";
    maintainers = with maintainers; [ ];
  };
}
