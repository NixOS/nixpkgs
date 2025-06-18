{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  requests,
  responses,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "matrix-client";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "matrix_client";
    inherit version;
    hash = "sha256-BnivQPLLLwkoqQikEMApdH1Ay5YaxaPxvQWqNVY8MVY=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "urllib3" ];

  dependencies = [
    requests
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  postPatch = ''
    substituteInPlace setup.py --replace \
      "pytest-runner~=5.1" ""
  '';

  pythonImportsCheck = [ "matrix_client" ];

  meta = {
    description = "Python Matrix Client-Server SDK";
    homepage = "https://github.com/matrix-org/matrix-python-sdk";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ olejorgenb ];
  };
}
