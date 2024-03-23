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
  version = "2.19.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ENS5ayrd7gffo2meChZ9930qjVq3+G5lkOqm6ofW3Bg=";
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
