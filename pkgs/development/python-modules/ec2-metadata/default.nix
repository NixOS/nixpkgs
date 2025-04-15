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
  version = "2.14.0";
  pyproject = true;

  src = fetchPypi {
    pname = "ec2_metadata";
    inherit version;
    hash = "sha256-svgzgXIgcu+ij2XcN+cmwKvToFMvIns/pqKtaEYMf+s=";
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
    description = "An easy interface to query the EC2 metadata API, with caching";
    homepage = "https://pypi.org/project/ec2-metadata/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers._9999years ];
    mainProgram = "ec2-metadata";
  };
}
