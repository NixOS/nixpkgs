{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  parameterized,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
}:

buildPythonPackage rec {
  pname = "nuheat";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "broox";
    repo = "python-nuheat";
    rev = "refs/tags/${version}";
    hash = "sha256-EsPuwILfKc1Bpvu0Qos7yooC3dBaqf46lWhiSZdu3sc=";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    mock
    parameterized
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "nuheat" ];

  meta = with lib; {
    description = "Library to interact with NuHeat Signature and Mapei Mapeheat radiant floor thermostats";
    homepage = "https://github.com/broox/python-nuheat";
    changelog = "https://github.com/broox/python-nuheat/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
