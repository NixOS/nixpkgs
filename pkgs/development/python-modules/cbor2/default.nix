{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cbor2";
  version = "5.6.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HFM8UN3oa+8caVBgIFSg/6PDduiw4gx7j1sQh5P2mD4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov" ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "cbor2" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/agronholm/cbor2/releases/tag/${version}";
    description = "Python CBOR (de)serializer with extensive tag support";
    mainProgram = "cbor2";
    homepage = "https://github.com/agronholm/cbor2";
    license = licenses.mit;
    maintainers = [ ];
  };
}
