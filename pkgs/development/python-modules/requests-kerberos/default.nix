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
  version = "0.13.0";

  # tests are not present in the PyPI version
  src = fetchFromGitHub {
    owner = "requests";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yvfg2cj3d10l8fd8kyal4hmpd7fd1c3bca13cj9ril5l573in76";
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
