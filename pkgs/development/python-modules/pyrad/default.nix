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
<<<<<<< HEAD
  version = "2.4-unstable-2025-12-02";
=======
  version = "2.4-unstable-2024-07-24";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyradius";
    repo = "pyrad";
<<<<<<< HEAD
    rev = "56649fc522faeb4bc105ac6d0f95b080e97c89aa";
    hash = "sha256-F+6ejSvIJDcLLb1o3m6r1es/PObB8H6eeSkAETJaftc=";
=======
    rev = "f42a57cb0e80de42949810057d36df7c4a6b5146";
    hash = "sha256-5SPVeBL1oMZ/XXgKch2Hbk6BRU24HlVl4oXZ2agF1h8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
