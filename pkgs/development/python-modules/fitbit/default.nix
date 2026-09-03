{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  mock,
  pytestCheckHook,
  python-dateutil,
  requests-mock,
  requests-oauthlib,
}:

buildPythonPackage rec {
  pname = "fitbit";
  version = "0.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "orcasgit";
    repo = "python-fitbit";
    rev = version;
    hash = "sha256-1u3h47lRBrJ7EUWBl5+RLGW4KHHqXqqrXbboZdy7VPA=";
  };

  postPatch = ''
    substituteInPlace fitbit_tests/test_api.py \
      --replace-fail assertRaisesRegexp assertRaisesRegex
  '';

  propagatedBuildInputs = [
    python-dateutil
    requests-oauthlib
  ];

  nativeCheckInputs = [
    freezegun
    mock
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "fitbit" ];

  meta = {
    description = "Fitbit API Python Client Implementation";
    homepage = "https://github.com/orcasgit/python-fitbit";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
