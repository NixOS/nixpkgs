{ lib
, buildPythonPackage
, factory_boy
, fetchFromGitHub
, inflection
, mock
, pytest
, pytestcache
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "pytest-factoryboy";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-factoryboy";
    rev = version;
    sha256 = "0v6b4ly0p8nknpnp3f4dbslfsifzzjx2vv27rfylx04kzdhg4m9p";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    factory_boy
    inflection
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytestcache
    pytest-cov
  ];

  pytestFlagsArray = [ "--ignore=docs" ];
  pythonImportsCheck = [ "pytest_factoryboy" ];

  meta = with lib; {
    description = "Integration of factory_boy into the pytest runner";
    homepage = "https://pytest-factoryboy.readthedocs.io/en/latest/";
    maintainers = with maintainers; [ winpat ];
    license = licenses.mit;
  };
}
