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
  version = "1.14.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "kellyjonbrazil";
    repo = "jc";
    rev = "v${version}";
    sha256 = "1vzzz7dlg6apxhcl0qkfdpp2v9d0q6jyafpfmklkcbjs31zvwcsw";
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
