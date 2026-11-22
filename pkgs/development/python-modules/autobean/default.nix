{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  beancount,
  nix-update-script,
  pdm-pep517,
  pytest-cov-stub,
  pytestCheckHook,
  python-dateutil,
  pyyaml,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "autobean";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SEIAROTg";
    repo = "autobean";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JTxrDER8iSPu9Rp/7Al7KVibWOVBXdHnq6fyGVMedas=";
  };

  build-system = [
    pdm-pep517
  ];

  dependencies = [
    beancount
    python-dateutil
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "autobean" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/SEIAROTg/autobean";
    description = "Collection of plugins and scripts that help automating bookkeeping with beancount";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
