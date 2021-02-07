{ lib
, buildPythonPackage
, fetchFromGitHub
, ruamel_yaml
, xmltodict
, pygments
, isPy27
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jc";
  version = "1.14.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "kellyjonbrazil";
    repo = "jc";
    rev = "v${version}";
    sha256 = "sha256-rYH4m7h2SPB1Io83ZUsqZ+Ll4XEi4Feuj4QYvaOJ2lY=";
  };

  propagatedBuildInputs = [ ruamel_yaml xmltodict pygments ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "This tool serializes the output of popular command line tools and filetypes to structured JSON output";
    homepage = "https://github.com/kellyjonbrazil/jc";
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
  };
}
