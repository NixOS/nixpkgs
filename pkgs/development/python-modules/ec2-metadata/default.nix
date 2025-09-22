{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "ec2-metadata";
  version = "2.16.0";
  pyproject = true;

  src = fetchPypi {
    pname = "ec2_metadata";
    inherit version;
    hash = "sha256-1Ca89aIVQ+B57Ov+0qoSNuUIgaGJENcya2J9WGE3mD8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
  ];

  pythonImportsCheck = [
    "ec2_metadata"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easy interface to query the EC2 metadata API, with caching";
    homepage = "https://pypi.org/project/ec2-metadata/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers._9999years ];
    mainProgram = "ec2-metadata";
  };
}
