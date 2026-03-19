{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "inwx-domrobot";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inwx";
    repo = "python-client";
    tag = "v${version}";
    hash = "sha256-Nbs3xroJD61NbpaiTdjA3VFxzXIlnqmB1d7SJDj8VN8=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "INWX" ];

  meta = {
    description = "INWX Domrobot Python Client";
    homepage = "https://github.com/inwx/python-client";
    changelog = "https://github.com/inwx/python-client/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
