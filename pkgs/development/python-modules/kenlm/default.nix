{
  fetchPypi,
  buildPythonPackage,
  lib,
  cmake,
  boost,
  eigen,
  zlib,
  bzip2,
  xz,
}:

buildPythonPackage rec {
  pname = "kenlm";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xGKLuftjyKb5JAA1uLA3OFz8QEy3LpM89Ih4KR7aweg=";
  };

  preBuild = ''
    cd ..
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    eigen
    zlib
    bzip2
    xz
  ];

  meta = {
    description = "Faster and Smaller Language Model Queries";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.lucasew ];
  };
}
