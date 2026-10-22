{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "ec2-metadata";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "ec2_metadata";
    inherit (finalAttrs) version;
    hash = "sha256-EtfiaM4MsWv27cS+1VF/EPwJAGqsw8NP80IdrpC7COo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    urllib3
  ];

  pythonImportsCheck = [
    "ec2_metadata"
  ];

  meta = {
    description = "Easy interface to query the EC2 metadata API, with caching";
    homepage = "https://pypi.org/project/ec2-metadata/";
    changelog = "https://github.com/adamchainz/ec2-metadata/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _9999years ];
    mainProgram = "imds";
  };
})
