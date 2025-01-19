{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  pyyaml,
  jsonlines,
  pythonOlder,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage rec {
  pname = "cloudflare";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eLEiLVMghLspq3ACV2F/r9gCokxa+bBW83m5lOkpr34=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    requests
    pyyaml
    jsonlines
  ];

  # tests require networking
  doCheck = false;

  pythonImportsCheck = [ "CloudFlare" ];

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
    maintainers = [ ];
  };
}
