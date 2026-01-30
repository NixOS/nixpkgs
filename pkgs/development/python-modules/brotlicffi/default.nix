{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  cffi,
  isPyPy,
  # overridden as pkgs.brotli
  brotli,
  setuptools,
  pycparser,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "brotlicffi";
  version = "1.2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-hyper";
    repo = "brotlicffi";
    tag = "v${version}";
    hash = "sha256-3/68qBfsFtH+7h3gPxUdkyHwG6qLbh+bVLrxzsb3bc4=";
  };

  build-system = [ setuptools ];

  buildInputs = [ brotli ];

  propagatedNativeBuildInputs = [ cffi ];

  dependencies = [ cffi ] ++ lib.optional isPyPy pycparser;

  preBuild = ''
    export USE_SHARED_BROTLI=1
  '';

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  # Test data is only available from libbrotli git checkout, not brotli.src
  doCheck = false;

  enabledTestPaths = [ "test/" ];

  pythonImportsCheck = [ "brotlicffi" ];

  meta = {
    changelog = "https://github.com/python-hyper/brotlicffi/blob/${src.tag}/HISTORY.rst";
    description = "Python CFFI bindings to the Brotli library";
    homepage = "https://github.com/python-hyper/brotlicffi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
