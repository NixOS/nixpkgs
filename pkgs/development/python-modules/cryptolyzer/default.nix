{
  lib,
  asn1crypto,
  attrs,
  beautifulsoup4,
  buildPythonPackage,
  certvalidator,
  colorama,
  cryptodatahub,
  cryptoparser,
  dnspython,
  fetchFromGitLab,
  oscrypto,
  pycryptodomex,
  requests,
  setuptools,
  setuptools-scm,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "cryptolyzer";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "coroner";
    repo = "cryptolyzer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wGPxK6yL2g7EPb1hyfenm3Op3xJIpJsaWQJcTXx6O/o=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asn1crypto
    attrs
    beautifulsoup4
    certvalidator
    colorama
    cryptodatahub
    cryptoparser
    dnspython
    oscrypto
    pycryptodomex
    requests
    urllib3
  ];

  # Tests require networking
  doCheck = false;

  postInstall = ''
    find $out -name "__pycache__" -type d | xargs rm -rv

    # Prevent creating more binary byte code later (e.g. during
    # pythonImportsCheck)
    export PYTHONDONTWRITEBYTECODE=1
  '';

  pythonImportsCheck = [ "cryptolyzer" ];

  passthru.updateScript = ../cryptodatahub/update.sh;

  meta = {
    description = "Cryptographic protocol analyzer";
    homepage = "https://gitlab.com/coroner/cryptolyzer";
    changelog = "https://gitlab.com/coroner/cryptolyzer/-/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mpl20;
    mainProgram = "cryptolyze";
    teams = with lib.teams; [ ngi ];
  };
})
