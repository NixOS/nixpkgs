{
  lib,
  stdenv,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pyspnego,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "requests-kerberos";
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "requests";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-s1Q3zqKPSuTkiFExr+axai9Eta1xjw/cip8xzfDGR88=";
  };

  propagatedBuildInputs =
    [
      cryptography
      requests
      pyspnego
    ]
    # Avoid broken Python krb5 package on Darwin
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) pyspnego.optional-dependencies.kerberos;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "requests_kerberos" ];

  meta = with lib; {
    description = "Authentication handler for using Kerberos with Python Requests";
    homepage = "https://github.com/requests/requests-kerberos";
    license = licenses.isc;
    maintainers = with maintainers; [ catern ];
  };
}
