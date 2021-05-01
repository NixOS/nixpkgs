{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pkgs
}:

buildPythonPackage rec {
  pname = "indexed-zstd";
  version = "1.2.2";

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "indexed_zstd";
    inherit version;
    sha256 = "1dy9l8aaq8n1mdi5xcpak7qfnv2bkb2rr16lhhaiksif69amx5id";
  };

  buildInputs = [ pkgs.zstd ];

  meta = with lib; {
    description = "Python library to seek within compressed zstd files";
    homepage = "https://github.com/martinellimarco/indexed_zstd";
    license = licenses.mit;
  };
}
