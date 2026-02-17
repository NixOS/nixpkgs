{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "linknlink";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xuanxuan000";
    repo = "python-linknlink";
    tag = version;
    hash = "sha256-ObPEcdDHi+SPFjuVKBtu7/5/IgHcam+IWblxxS3+mmI=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  pythonImportsCheck = [ "linknlink" ];

  # Module has no test
  doCheck = false;

  meta = {
    description = "Module and CLI for controlling Linklink devices locally";
    homepage = "https://github.com/xuanxuan000/python-linknlink";
    changelog = "https://github.com/xuanxuan000/python-linknlink/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
