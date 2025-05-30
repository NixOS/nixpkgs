{
  lib,
  buildPythonPackage,
  fetchPypi,
  ntc-templates,
  paramiko,
  poetry-core,
  pyserial,
  pythonOlder,
  pyyaml,
  rich,
  ruamel-yaml,
  scp,
  textfsm,
}:

buildPythonPackage rec {
  pname = "netmiko";
  version = "4.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-29/CC2yq+OXXpXC7G0Kia5pvjYI06R9cZfTb/gwOT1A=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry>=1.6.1" "poetry-core" \
      --replace-fail "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    ntc-templates
    paramiko
    pyserial
    pyyaml
    rich
    ruamel-yaml
    scp
    textfsm
  ];

  # Tests require closed-source pyats and genie packages
  doCheck = false;

  pythonImportsCheck = [ "netmiko" ];

  meta = with lib; {
    description = "Multi-vendor library to simplify Paramiko SSH connections to network devices";
    homepage = "https://github.com/ktbyers/netmiko/";
    changelog = "https://github.com/ktbyers/netmiko/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.astro ];
  };
}
