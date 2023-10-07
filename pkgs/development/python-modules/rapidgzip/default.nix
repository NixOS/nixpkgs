{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, nasm
}:

buildPythonPackage rec {
  pname = "rapidgzip";
  version = "0.10.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gtxF9V7OQb34Z0cCuTh/Lbe1ttCbdaY0zpM3KHHGGuw=";
  };

  nativeBuildInputs = [ nasm ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "rapidgzip" ];

  meta = with lib; {
    description = "Python library for parallel decompression and seeking within compressed gzip files";
    homepage = "https://github.com/mxmlnkn/rapidgzip";
    license = licenses.mit; # dual MIT and asl20, https://internals.rust-lang.org/t/rationale-of-apache-dual-licensing/8952
    maintainers = with lib.maintainers; [ mxmlnkn ];
    platforms = platforms.all;
  };
}
