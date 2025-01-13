{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  websocket-client,
  zeroconf,
  pytestCheckHook,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "libsoundtouch";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CharlesBlonde";
    repo = "libsoundtouch";
    tag = version;
    hash = "sha256-am8nHPdtKMh8ZA/jKgz2jnltpvgEga8/BjvP5nrhgvI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'enum-compat>=0.0.2'," ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    requests
    websocket-client
    zeroconf
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # mock data order mismatch
    "test_select_content_item"
    "test_snapshot_restore"
  ];

  pythonImportsCheck = [ "libsoundtouch" ];

  meta = with lib; {
    description = "Bose Soundtouch Python library";
    homepage = "https://github.com/CharlesBlonde/libsoundtouch";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
