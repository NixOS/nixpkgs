{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  nix-update-script,
  setuptools,
  paup-cli,
  paupIntegration ? false,
}:

let
  paupPath = if paupIntegration then lib.getExe paup-cli else "NONE";
in
buildPythonPackage rec {
  pname = "dendropy";
  version = "5.0.8";

  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "jeetsukumaran";
    repo = "dendropy";
    tag = "v${version}";
    hash = "sha256-AmKm9V4XZQRuAfe0R5r5/wicno9iTZ6nbwHyHvMijz0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '["pytest-runner"],' '[],'

    substituteInPlace src/dendropy/interop/paup.py \
      --replace 'PAUP_PATH = os.environ.get(metavar.DENDROPY_PAUP_PATH_ENVAR, "paup")' 'PAUP_PATH = os.environ.get(metavar.DENDROPY_PAUP_PATH_ENVAR, "${paupPath}")'
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dendropy" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for phylogenetic computing";
    homepage = "https://jeetsukumaran.github.io/DendroPy/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      unode
      pandapip1
    ];
  };
}
