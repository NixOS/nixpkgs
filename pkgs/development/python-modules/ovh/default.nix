{ lib
, buildPythonPackage
, fetchPypi
, mock
, nose
, requests
, yanc
}:

buildPythonPackage rec {
  pname = "ovh";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IQzwu0gwfPNPOLQLCO99KL5Hu2094Y+acQBFXVGzHhU=";
  };

  propagatedBuildInputs = [
    requests
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    mock
    nose
    yanc
  ];

  # requires network
  checkPhase = ''
    nosetests . \
      -e test_config_get_conf \
      -e test_config_get_custom_conf \
      -e test_endpoints \
      -e test_init_from_custom_config
  '';

  meta = with lib; {
    description = "Thin wrapper around OVH's APIs";
    homepage = "https://github.com/ovh/python-ovh";
    changelog = "https://github.com/ovh/python-ovh/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ makefu ];
  };
}
