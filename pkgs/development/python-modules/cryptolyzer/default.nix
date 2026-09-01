{
  lib,
  attrs,
  beautifulsoup4,
  buildPythonPackage,
  certvalidator,
  colorama,
  cryptoparser,
  dnspython,
  fetchFromGitLab,
  pathlib2,
  pyfakefs,
  python-dateutil,
  pycryptodome,
  requests,
  setuptools,
  setuptools-scm,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "cryptolyzer";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "coroner";
    repo = "cryptolyzer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2U+7y88m+r1LzOiDp4QydnlQCjBfN6p56Yh9mZMjnyE=";
  };

  pythonRemoveDeps = [ "bs4" ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    attrs
    beautifulsoup4
    certvalidator
    colorama
    cryptoparser
    dnspython
    pathlib2
    pyfakefs
    python-dateutil
    pycryptodome
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
    changelog = "https://gitlab.com/coroner/cryptolyzer/-/blob/v${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mpl20;
    mainProgram = "cryptolyze";
    teams = with lib.teams; [ ngi ];
  };
})
