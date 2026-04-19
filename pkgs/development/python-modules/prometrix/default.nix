{
  lib,
  boto3,
  botocore,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  prometheus-api-client,
  pydantic,
  pythonAtLeast,
  requests,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "prometrix";
  version = "0.2.11-unstable-2026-03-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robusta-dev";
    repo = "prometrix";
    rev = "e84d6639226aea5f9ef1ea565d1932bf29807344";
    hash = "sha256-V4lG47vn+nXa1H8Tp/RsZ2KUk7HhojrzNZQBlnWL1eE=";
  };

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    # Transitive dependency version pins for CVE patches, not direct imports
    "fonttools"
    "idna"
    "pillow"
    "zipp"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    boto3
    botocore
    prometheus-api-client
    pydantic
    requests
  ];

  # Fixture is missing
  # https://github.com/robusta-dev/prometrix/issues/9
  doCheck = false;

  pythonImportsCheck = [ "prometrix" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Unified Prometheus client";
    longDescription = ''
      This Python package provides a unified Prometheus client that can be used
      to connect to and query various types of Prometheus instances.
    '';
    homepage = "https://github.com/robusta-dev/prometrix";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
