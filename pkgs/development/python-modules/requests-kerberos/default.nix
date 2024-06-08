{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pykerberos,
  pyspnego,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "requests-kerberos";
  version = "0.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "requests";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Y9dTzFCgVmSnbnTE0kEfjpEkXDEA+uOqFHLkSC27YGg=";
  };

  propagatedBuildInputs = [
    cryptography
    requests
    pykerberos
    pyspnego
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  # avoid needing to package krb5
  postPatch = ''
    substituteInPlace setup.py \
    --replace "pyspnego[kerberos]" "pyspnego"
  '';

  pythonImportsCheck = [ "requests_kerberos" ];

  meta = with lib; {
    description = "An authentication handler for using Kerberos with Python Requests";
    homepage = "https://github.com/requests/requests-kerberos";
    license = licenses.isc;
    maintainers = with maintainers; [ catern ];
  };
}
