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
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DanSheps";
    repo = "netbox-routing";
    tag = "v${version}";
    hash = "sha256-QJ4/6eRPo2SIgOWNiK+3jrXW+KaXvzERLcXQqKwCNDU=";
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
    description = "A NetBox plugin for tracking all kinds of routing information";
    homepage = "https://github.com/DanSheps/netbox-routing";
    changelog = "https://github.com/DanSheps/netbox-routing/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benley ];
  };
}
