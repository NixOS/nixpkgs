{
  lib,
  buildPythonPackage,
  setuptools,
  fetchFromGitLab,
}:

buildPythonPackage rec {
  pname = "git-versioner";
  version = "7.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "alelec";
    repo = "__version__";
    tag = "v${version}";
    hash = "sha256-bnpuFJSd4nBXJA75V61kiB+nU5pUzdEAIScfKx7aaGU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "__version__" ];

  meta = {
    description = "Manage current / next version for project";
    homepage = "https://gitlab.com/alelec/__version__";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ slotThe ];
  };
}
