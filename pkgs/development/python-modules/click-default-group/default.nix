{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  flit-core,
}:

buildPythonPackage rec {
  pname = "click-default-group";
  version = "1.2.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-default-group";
    tag = "v${version}";
    hash = "sha256-9Vk4LdgLDAWG2YCQPLKR6PIVnULmpOoe7RtS8DgWARo=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "click_default_group" ];

  meta = with lib; {
    description = "Group to invoke a command without explicit subcommand name";
    homepage = "https://github.com/click-contrib/click-default-group";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
