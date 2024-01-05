{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "opencontainers";
  version = "0.0.14";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/eO4CZtWtclWQV34kz4iJ+GRToBaJ3uETy+eUjQXOPI=";
  };

  postPatch = ''
    sed -i "/pytest-runner/d" setup.py
  '';

  passthru.optional-dependencies.reggie = [
    requests
  ];

  pythonImportsCheck = [
    "opencontainers"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.reggie;

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python module for oci specifications";
    homepage = "https://github.com/vsoch/oci-python";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
