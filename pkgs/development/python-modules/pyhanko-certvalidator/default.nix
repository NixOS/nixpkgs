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

buildPythonPackage rec {
  pname = "pyhanko-certvalidator";
  version = "0.29.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "pyhanko";
    tag = "pyhanko-certvalidator/v${version}";
    hash = "sha256-ZDHAcI2yoiVifYt05V85lz8mJmoyi10g4XoLQ+LhLHE=";
  };

  sourceRoot = "${src.name}/pkgs/pyhanko-certvalidator";

  postPatch = ''
    substituteInPlace src/pyhanko_certvalidator/version.py \
      --replace-fail "0.0.0.dev1" "${version}" \
      --replace-fail "(0, 0, 0, 'dev1')" "tuple(\"${version}\".split(\".\"))"
    substituteInPlace pyproject.toml --replace-fail "0.0.0.dev1" "${version}"
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex=pyhanko-certvalidator/v(.*)"
    ];
  };

  meta = with lib; {
    description = "Python library for validating X.509 certificates and paths";
    homepage = "https://github.com/MatthiasValvekens/pyHanko/tree/master/pkgs/pyhanko-certvalidator";
    changelog = "https://github.com/MatthiasValvekens/pyhanko/blob/pyhanko-certvalidator/${src.tag}/docs/changelog.rst#pyhanko-certvalidator";
    license = licenses.mit;
    maintainers = [ lib.maintainers.antonmosich ];
  };
}
