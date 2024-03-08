{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, brotli
, lz4
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
  version = "0.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oETe4pFz1q+6zye8rDna+JtlTdQYz6AJq4LZF4qa5So=";
  };

  preBuild = ''
    ln -s ${kaitai_compress}/python/kaitai kaitai
    sed '32ipackages = kaitai/compress' -i setup.cfg
  '';

  propagatedBuildInputs = [
    brotli
    lz4
  ];

  # no tests
  dontCheck = true;

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
