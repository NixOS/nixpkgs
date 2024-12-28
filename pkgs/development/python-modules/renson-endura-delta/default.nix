{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "renson-endura-delta";
  version = "1.7.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jimmyd-be";
    repo = "Renson-endura-delta-library";
    rev = "refs/tags/${version}";
    hash = "sha256-ndk0qcRUWxUimNHg62UgeYK/MRKQd3e4JQDh9x8vFj8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'" ""
  '';

  build-system = [ setuptools ];

  dependencies = [ requests ];

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
