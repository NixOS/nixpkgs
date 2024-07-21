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
  urllib3,
}:

buildPythonPackage rec {
  pname = "cryptolyzer";
  version = "0.12.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qc1L4F2U/nk37s/mIa2YgJZqC2dkPsB/Si84SEl576Q=";
  };

  postPatch = ''
    substituteInPlace requirements.txt  \
      --replace-warn "attrs>=20.3.0,<22.0.1" "attrs>=20.3.0" \
      --replace-warn "bs4" "beautifulsoup4"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [ "cryptolyzer" ];

  meta = with lib; {
    description = "Cryptographic protocol analyzer";
    homepage = "https://gitlab.com/coroner/cryptolyzer";
    changelog = "https://gitlab.com/coroner/cryptolyzer/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kranzes ];
  };
}
