{ lib
, buildPythonPackage
, certifi
, fetchFromGitHub
, pyarrow
, pytestCheckHook
, python-dateutil
, pythonOlder
, reactivex
, setuptools
, urllib3
}:

buildPythonPackage rec {
  pname = "influxdb3-python";
  version = "0.3.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "InfluxCommunity";
    repo = "influxdb3-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZKN3chJvtOenk2jp02rvw+HooJcee0hwxWoLvEYjfcg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    certifi
    pyarrow
    python-dateutil
    reactivex
    urllib3
  ];

  # Missing ORC support
  # https://github.com/NixOS/nixpkgs/issues/212863
  # nativeCheckInputs = [
  #   pytestCheckHook
  # ];
  #
  # pythonImportsCheck = [
  #   "influxdb_client_3"
  # ];

  meta = with lib; {
    description = "Python module that provides a simple and convenient way to interact with InfluxDB 3.0";
    homepage = "https://github.com/InfluxCommunity/influxdb3-python";
    changelog = "https://github.com/InfluxCommunity/influxdb3-python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
