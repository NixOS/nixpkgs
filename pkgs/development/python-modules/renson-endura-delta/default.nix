{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "renson-endura-delta";
  version = "1.7.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  # github repo is gone
  src = fetchPypi {
    pname = "renson_endura_delta";
    inherit version;
    hash = "sha256-bL4faNFh+ocNNspZCXE6/UZ4nH3mKkHSAEvwtN0xfoE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'" ""
  '';

  build-system = [ setuptools ];

  dependencies = [ requests ];

  doCheck = false; # no tests in sdist

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "renson_endura_delta" ];

  meta = with lib; {
    description = "Module to interact with Renson endura delta";
    homepage = "https://github.com/jimmyd-be/Renson-endura-delta-library";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
