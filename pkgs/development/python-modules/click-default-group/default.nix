{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pytestCheckHook,
  flit-core,
}:

buildPythonPackage rec {
  pname = "click-default-group";
  version = "1.2.4";
  pyproject = true;

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

  meta = {
    description = "Group to invoke a command without explicit subcommand name";
    homepage = "https://github.com/click-contrib/click-default-group";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jakewaksbaum ];
  };
}
