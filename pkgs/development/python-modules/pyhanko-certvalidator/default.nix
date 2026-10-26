{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  asn1crypto,
  cryptography,
  oscrypto,
  requests,
  uritools,

  aiohttp,
  freezegun,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyhanko-certvalidator";
  version = "0.31.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "pyhanko";
    tag = "pyhanko-certvalidator/v${finalAttrs.version}";
    hash = "sha256-PyCVebWLtDeYFDxAE2mZ8tGaVQF60czU8ZyVbSyVONo=";
  };

  sourceRoot = "${finalAttrs.src.name}/pkgs/pyhanko-certvalidator";

  postPatch = ''
    substituteInPlace src/pyhanko_certvalidator/version.py \
      --replace-fail "0.0.0.dev1" "${finalAttrs.version}" \
      --replace-fail "(0, 0, 0, 'dev1')" "tuple(\"${finalAttrs.version}\".split(\".\"))"
    substituteInPlace pyproject.toml --replace-fail "0.0.0.dev1" "${finalAttrs.version}"
  '';

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    cryptography
    oscrypto
    requests
    uritools
  ];

  nativeCheckInputs = [
    aiohttp
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyhanko_certvalidator" ];

  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex=pyhanko-certvalidator/v(.*)"
      ];
    };
  };

  meta = {
    description = "Python library for validating X.509 certificates and paths";
    homepage = "https://github.com/MatthiasValvekens/pyHanko/tree/master/pkgs/pyhanko-certvalidator";
    changelog = "https://github.com/MatthiasValvekens/pyhanko/blob/${finalAttrs.src.tag}/docs/changelog.rst#pyhanko-certvalidator";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.antonmosich ];
  };
})
