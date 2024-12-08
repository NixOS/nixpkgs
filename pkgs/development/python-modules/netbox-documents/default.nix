{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  drf-extra-fields,
  python,
  netbox,
}:

buildPythonPackage rec {
  pname = "netbox-documents";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jasonyates";
    repo = "netbox-documents";
    rev = "v${version}";
    hash = "sha256-Uijdaicbx9A9fBgFx3zyhhFlokFdb9TSolnExbfkkc4=";
  };

  build-system = [ setuptools ];

  dependencies = [ drf-extra-fields ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;
  pythonImportsCheck = [ "netbox_documents" ];

  meta = {
    description = "Plugin designed to faciliate the storage of site, circuit, device type and device specific documents within NetBox";
    homepage = "https://github.com/jasonyates/netbox-documents";
    changelog = "https://github.com/jasonyates/netbox-documents/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
