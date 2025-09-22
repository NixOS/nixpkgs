{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchFromGitHub,
  brotli,
  lz4,
  setuptools,
}:

let
  kaitai_compress = fetchFromGitHub {
    owner = "kaitai-io";
    repo = "kaitai_compress";
    rev = "12f4cffb45d95b17033ee4f6679987656c6719cc";
    hash = "sha256-l3rGbblUgxO6Y7grlsMEiT3nRIgUZV1VqTyjIgIDtyA=";
  };
in
buildPythonPackage rec {
  pname = "kaitaistruct";
  version = "0.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BT7nZCiOeLjlOs90jpczJorL1Xm42CpCexgFRTYl10s=";
  };

  patches = [ ./01-add-kaitai-compress.patch ];

  preBuild = ''
    ln -s ${kaitai_compress}/python/kaitai kaitai
  '';

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    brotli
    lz4
  ];

  doCheck = false; # no tests in upstream

  pythonImportsCheck = [
    "kaitaistruct"
    "kaitai.compress"
  ];

  meta = with lib; {
    description = "Kaitai Struct: runtime library for Python";
    homepage = "https://github.com/kaitai-io/kaitai_struct_python_runtime";
    license = licenses.mit;
    maintainers = [ ];
  };
}
