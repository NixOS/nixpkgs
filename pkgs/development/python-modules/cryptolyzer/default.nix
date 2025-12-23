{
  lib,
  attrs,
  beautifulsoup4,
  buildPythonPackage,
  certvalidator,
  colorama,
  cryptoparser,
  dnspython,
  fetchPypi,
  pathlib2,
  pyfakefs,
  python-dateutil,
  pythonOlder,
  requests,
  setuptools,
  setuptools-scm,
  urllib3,
}:

buildPythonPackage rec {
  pname = "cryptolyzer";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rRiRaXONLMNirKsK+QZWMSvaGeSLrHN9BpM8dhxoaxY=";
  };

  patches = [
    # https://gitlab.com/coroner/cryptolyzer/-/merge_requests/4
    ./fix-dirs-exclude.patch
  ];

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

  meta = {
    description = "Cryptographic protocol analyzer";
    homepage = "https://gitlab.com/coroner/cryptolyzer";
    changelog = "https://gitlab.com/coroner/cryptolyzer/-/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    mainProgram = "cryptolyze";
    maintainers = with lib.maintainers; [ kranzes ];
    teams = with lib.teams; [ ngi ];
  };
}
