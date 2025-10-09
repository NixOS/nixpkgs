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
  version = "2.17.0";
  pyproject = true;

  src = fetchPypi {
    pname = "ec2_metadata";
    inherit version;
    hash = "sha256-rZilr9j09J9ojkiZ3FBSV9oyNzSHYezusPx/x9AMyQ0=";
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
