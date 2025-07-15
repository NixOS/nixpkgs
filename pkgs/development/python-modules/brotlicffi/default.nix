{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  cffi,
  # overridden as pkgs.brotli
  brotli,
  setuptools,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "brotlicffi";
  version = "1.1.0.0";
  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-hyper";
    repo = "brotlicffi";
    rev = "v${version}";
    sha256 = "sha256-oW4y1WBJ7+4XwNwwSSR0qUqN03cZYXUYQ6EAwce9dzI=";
  };

  build-system = [ setuptools ];

  buildInputs = [ brotli ];

  propagatedNativeBuildInputs = [ cffi ];

  dependencies = [ cffi ];

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

  meta = with lib; {
    description = "Python CFFI bindings to the Brotli library";
    homepage = "https://github.com/python-hyper/brotlicffi";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
