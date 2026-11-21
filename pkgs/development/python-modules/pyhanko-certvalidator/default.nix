{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  asn1crypto,
  certifi,
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
  version = "0.33.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "pyhanko";
    tag = "pyhanko-certvalidator/v${finalAttrs.version}";
    hash = "sha256-od9t6OmCYQ+j5HGTPa44VxNqTgT1S53VTBhjqD5/Ynw=";
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
    aiohttp
    asn1crypto
    certifi
    cryptography
    oscrypto
    uritools
  ];

  optional-dependencies = {
    requests = [ requests ];
  };

  nativeCheckInputs = [
    aiohttp
    freezegun
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

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
