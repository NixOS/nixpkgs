{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pyserial,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "nrf802154-sniffer";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nordicsemi";
    repo = "nRF-Sniffer-for-802.15.4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xzulfhbxQIreyo5rMtaapFTv/A0FWVXb+x1sjTO5lpo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "name=DISTRIBUTION_NAME," "name=DISTRIBUTION_NAME, version='${finalAttrs.version}',"
  '';

  build-system = [ setuptools ];

  dependencies = [ pyserial ];

  pythonImportsCheck = [ "nrf802154_sniffer" ];

  # Module has no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Module to enable NRF-based 802.15.4 sniffer";
    homepage = "https://github.com/nordicsemi/nRF-Sniffer-for-802.15.4";
    changelog = "https://github.com/nordicsemi/nRF-Sniffer-for-802.15.4/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
