{ lib
, buildPythonPackage
, fetchFromGitHub
, ruamel-yaml
, xmltodict
, pygments
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jc";
  version = "1.23.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kellyjonbrazil";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3AH/NKYMACNuS0I2RsyU+L5Vksdv9H/q3aV1US64rk0=";
  };

  propagatedBuildInputs = [ ruamel-yaml xmltodict pygments ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jc" ];

  # tests require timezone to set America/Los_Angeles
  doCheck = false;

  meta = with lib; {
    description = "This tool serializes the output of popular command line tools and filetypes to structured JSON output";
    homepage = "https://github.com/kellyjonbrazil/jc";
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
    changelog = "https://github.com/kellyjonbrazil/jc/blob/v${version}/CHANGELOG";
  };
}
