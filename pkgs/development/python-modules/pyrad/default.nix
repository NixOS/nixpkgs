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
  version = "2.4-unstable-2024-07-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyradius";
    repo = "pyrad";
    rev = "f42a57cb0e80de42949810057d36df7c4a6b5146";
    hash = "sha256-5SPVeBL1oMZ/XXgKch2Hbk6BRU24HlVl4oXZ2agF1h8=";
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
