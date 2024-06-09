{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  cffi,
  brotli,
}:

buildPythonPackage rec {
  pname = "brotlicffi";
  version = "1.1.0.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-hyper";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oW4y1WBJ7+4XwNwwSSR0qUqN03cZYXUYQ6EAwce9dzI=";
  };

  buildInputs = [ brotli ];

  propagatedNativeBuildInputs = [ cffi ];

  propagatedBuildInputs = [ cffi ];

  preBuild = ''
    export USE_SHARED_BROTLI=1
  '';

  # Test data is not available, only when using libbrotli git checkout
  doCheck = false;

  pythonImportsCheck = [ "brotlicffi" ];

  meta = with lib; {
    description = "Python CFFI bindings to the Brotli library";
    homepage = "https://github.com/python-hyper/brotlicffi";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
