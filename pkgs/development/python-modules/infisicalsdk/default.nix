{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  setuptools,
  python-dateutil,
  aenum,
  requests,
  boto3,
  botocore,
}:

buildPythonPackage (finalAttrs: {
  pname = "infisicalsdk";
  version = "1.0.17";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Infisical";
    repo = "python-sdk-official";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P8tpcXznT8lLH8iQD4IXK4SX44KiZs280LI8+VWxlqw=";
  };

  # fix version in setup.py AND pyproject.toml
  postPatch = ''
    substituteInPlace ./setup.py --replace-fail \
      'VERSION = "1.0.1"' 'VERSION = "${finalAttrs.version}"'
  '';
  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    aenum
    requests
    boto3
    botocore
  ];

  pythonImportsCheck = [ "infisical_sdk" ];

  doCheck = false; # tests require network access + api keys

  meta = {
    homepage = "https://github.com/Infisical/python-sdk-official";
    description = "Infisical Python SDK";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artur-sannikov ];
    teams = [ lib.teams.infisical ];
  };
})
