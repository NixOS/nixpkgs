{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools-scm,
  backports-tarfile,
}:

buildPythonPackage rec {
  pname = "jaraco-context";
  version = "6.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.context";
    tag = "v${version}";
    hash = "sha256-gkFRBgVu79o2wCZqVdqChND+763uR6lAuWFwYHxHIq8=";
  };

  postPatch = ''
    sed -i "/coherent.licensed/d" pyproject.toml
  '';

  pythonNamespaces = [ "jaraco" ];

  build-system = [ setuptools-scm ];

  dependencies = lib.optionals (pythonOlder "3.12") [ backports-tarfile ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "jaraco.context" ];

  meta = {
    description = "Python module for context management";
    homepage = "https://github.com/jaraco/jaraco.context";
    changelog = "https://github.com/jaraco/jaraco.context/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
