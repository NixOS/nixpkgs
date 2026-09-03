{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptomobile,
  pysctp,
  lxml,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "pycrate";
  version = "0.8.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pycrate-org";
    repo = "pycrate";
    tag = finalAttrs.version;
    hash = "sha256-FUVEkzfDIbPw4e2ADMCnqycZjg9m1fvyLIU9xHwO6jA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptomobile # for NASLTE / NAS5G / corenet
    pysctp # for corenet
    lxml # for diameter_dict
  ];

  pythonImportsCheck = [
    "pycrate_core"
    "pycrate_ether"
    "pycrate_media"
    "pycrate_asn1c"
    "pycrate_asn1dir"
    "pycrate_asn1rt"
    "pycrate_csn1"
    "pycrate_csn1dir"
    "pycrate_mobile"
    "pycrate_diameter"
    "pycrate_corenet"
    "pycrate_sys"
    "pycrate_crypto"
    "pycrate_osmo"
    "pycrate_gmr1"
    "pycrate_gmr1_csn1"
  ];

  checkPhase = ''
    runHook preCheck

    cd test # working directory must be correct, so that resources can be accessed using relatives paths
    find . -name '*.py' -exec ${python.interpreter} {} \;

    runHook postCheck
  '';

  meta = {
    description = "Software suite to handle various data and protocol formats";
    homepage = "https://github.com/pycrate-org/pycrate";
    changelog = "https://github.com/pycrate-org/pycrate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
