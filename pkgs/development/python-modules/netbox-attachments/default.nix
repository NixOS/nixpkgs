{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  python,
  netbox,
  django,
  netaddr,
}:
buildPythonPackage rec {
  pname = "netbox-attachments";
  version = "8.0.4";
  pyproject = true;

  disabled = python.pythonVersion != netbox.python.pythonVersion;

  src = fetchFromGitHub {
    owner = "Kani999";
    repo = "netbox-attachments";
    tag = version;
    hash = "sha256-wVTI0FAj6RaEaE6FhvHq4ophnCspobqL2SnTYVynlxs=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    netbox
    django
    netaddr
  ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_attachments" ];

  meta = {
    description = "Plugin to manage attachments for any model";
    homepage = "https://github.com/Kani999/netbox-attachments";
    changelog = "https://github.com/Kani999/netbox-attachments/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
