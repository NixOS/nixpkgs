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
  version = "1.20.4";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kellyjonbrazil";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fiRd433bb0neUeyBtS3KbnYoJJzbGvKrZ29dofGYp0s=";
  };

  propagatedBuildInputs = [ ruamel-yaml xmltodict pygments ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jc" ];

  # tests require timezone to set America/Los_Angeles
  doCheck = false;

  meta = with lib; {
    description = "This tool serializes the output of popular command line tools and filetypes to structured JSON output";
    homepage = "https://github.com/kellyjonbrazil/jc";
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
  };
}
