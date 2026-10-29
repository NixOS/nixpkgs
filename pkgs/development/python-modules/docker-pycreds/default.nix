{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  pythonAtLeast,
  distutils,
}:

buildPythonPackage (finalAttrs: {
  pname = "docker-pycreds";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shin-";
    repo = "dockerpy-creds";
    tag = finalAttrs.version;
    hash = "sha256-yYsMsRW6Bb8vmwT0mPjs0pRqBbznGtHnGb3JNHjLjys=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    six
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    distutils
  ];

  pythonImportsCheck = [ "dockerpycreds" ];

  # require docker-credential-helpers binaries
  doCheck = false;

  meta = {
    description = "Python bindings for the docker credentials store API";
    homepage = "https://github.com/shin-/dockerpy-creds";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
