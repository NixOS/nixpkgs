{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  unittestCheckHook,
  poetry-core,
}:

buildPythonPackage {
  pname = "pyrad";
  version = "2.4-unstable-2025-12-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyradius";
    repo = "pyrad";
    rev = "56649fc522faeb4bc105ac6d0f95b080e97c89aa";
    hash = "sha256-F+6ejSvIJDcLLb1o3m6r1es/PObB8H6eeSkAETJaftc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'repository =' 'Repository ='
  '';

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "pyrad" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Python RADIUS Implementation";
    homepage = "https://github.com/pyradius/pyrad";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
