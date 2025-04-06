{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  setuptools,
  netbox,
}:
buildPythonPackage rec {
  pname = "netbox-attachments";
  version = "7.1.0";
  pyproject = true;

  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "Kani999";
    repo = "netbox-attachments";
    tag = version;
    hash = "sha256-uSp6z2jSb+kX5YspIV0essqRHGtOlZ5m0hMS6OO9Trk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

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
