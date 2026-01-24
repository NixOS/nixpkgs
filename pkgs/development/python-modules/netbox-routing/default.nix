{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  pytestCheckHook,
  python,
  django-polymorphic,
}:

buildPythonPackage rec {
  pname = "netbox-routing";
  version = "0.4.0b1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DanSheps";
    repo = "netbox-routing";
    tag = "v${version}";
    hash = "sha256-qpfZgGltzfor7twMep8YxM9+z/xkgoxWq4WuD6NoMmg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_routing" ];

  dependencies = [ django-polymorphic ];

  meta = {
    description = "NetBox plugin for tracking all kinds of routing information";
    homepage = "https://github.com/DanSheps/netbox-routing";
    changelog = "https://github.com/DanSheps/netbox-routing/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benley ];
  };
}
