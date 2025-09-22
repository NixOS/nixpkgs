{
  lib,
  asn1crypto,
  attrs,
  buildPythonPackage,
  cryptodatahub,
  fetchPypi,
  python-dateutil,
  pythonOlder,
  setuptools,
  setuptools-scm,
  urllib3,
}:

buildPythonPackage rec {
  pname = "cryptoparser";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bEvhMVcm9sXlfhxUD2K4N10nusgxpGYFJQLtJE1/qok=";
  };

  patches = [
    # https://gitlab.com/coroner/cryptoparser/-/merge_requests/2
    ./fix-dirs-exclude.patch
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asn1crypto
    attrs
    cryptodatahub
    python-dateutil
    urllib3
  ];

  postInstall = ''
    find $out -name "__pycache__" -type d | xargs rm -rv

    # Prevent creating more binary byte code later (e.g. during
    # pythonImportsCheck)
    export PYTHONDONTWRITEBYTECODE=1
  '';

  pythonImportsCheck = [ "cryptoparser" ];

  meta = with lib; {
    description = "Security protocol parser and generator";
    homepage = "https://gitlab.com/coroner/cryptoparser";
    changelog = "https://gitlab.com/coroner/cryptoparser/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kranzes ];
  };
}
