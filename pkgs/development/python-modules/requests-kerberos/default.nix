{ lib
, fetchFromGitHub
, buildPythonPackage
, cryptography
, requests
, pykerberos
, pyspnego
, pytestCheckHook
, pytest-mock
, mock
}:

buildPythonPackage rec {
  pname = "requests-kerberos";
  version = "0.14.0";

  # tests are not present in the PyPI version
  src = fetchFromGitHub {
    owner = "requests";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s30pcnlir3j2jmf7yh065f294cf3x0x5i3ldskn8mm0a3657mv3";
  };

  # avoid needing to package krb5
  postPatch = ''
    substituteInPlace setup.py \
    --replace "pyspnego[kerberos]" "pyspnego"
  '';

  propagatedBuildInputs = [
    cryptography
    requests
    pykerberos
    pyspnego
  ];

  checkInputs = [
    mock
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "requests_kerberos" ];

  meta = with lib; {
    description = "An authentication handler for using Kerberos with Python Requests";
    homepage = "https://github.com/requests/requests-kerberos";
    license = licenses.isc;
    maintainers = with maintainers; [ catern ];
  };
}
