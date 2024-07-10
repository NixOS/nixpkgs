{
  lib,
  arrow,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-datafiles,
  pytest-vcr,
  pytestCheckHook,
  python-box,
  pythonOlder,
  responses,
  requests,
}:

buildPythonPackage rec {
  pname = "restfly";
  version = "1.4.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stevemcgrath";
    repo = pname;
    rev = version;
    hash = "sha256-PPXJHatJKve9fIjveVYRnTSIDHFmnSDWTnkgO91twJs=";
  };

  propagatedBuildInputs = [
    requests
    arrow
    python-box
  ];

  nativeCheckInputs = [
    pytest-datafiles
    pytest-vcr
    pytestCheckHook
    responses
  ];

  disabledTests = [
    # Test requires network access
    "test_session_ssl_error"
  ];

  pythonImportsCheck = [ "restfly" ];

  meta = with lib; {
    description = "Python RESTfly API Library Framework";
    homepage = "https://github.com/stevemcgrath/restfly";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
