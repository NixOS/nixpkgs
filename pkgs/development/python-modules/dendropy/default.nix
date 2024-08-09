{
  lib,
  stdenv,
  checkMeta,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  nix-update-script,
  setuptools,
  paup,
  paupIntegration ? (checkMeta.checkValidity paup).valid == "yes"
}:

buildPythonPackage rec {
  pname = "dendropy";
  version = "5.0.1";

  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "jeetsukumaran";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4VkFkY4/hDfb6elOSTDia6tRJm73c1YP9nBW2dJsxsI=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace '["pytest-runner"],' '[],'
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dendropy" ];

  env.DENDROPY_PAUP_EXECUTABLE_PATH = if paupIntegration then lib.getExe paup else "NONE";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for phylogenetic computing";
    homepage = "https://jeetsukumaran.github.io/DendroPy/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ unode pandapip1 ];
  };
}
