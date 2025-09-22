{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "opencontainers";
  version = "0.0.15";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o6QBJMxo7aVse0xauSTxi1UEW4RYrKlhH1v6g/fvrv4=";
  };

  postPatch = ''
    sed -i "/pytest-runner/d" setup.py
  '';

  optional-dependencies.reggie = [ requests ];

  pythonImportsCheck = [ "opencontainers" ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.reggie;

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python module for oci specifications";
    homepage = "https://github.com/vsoch/oci-python";
    license = licenses.mpl20;
    maintainers = [ ];
  };
}
