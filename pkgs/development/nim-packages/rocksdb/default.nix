{ lib, buildNimPackage, fetchFromGitHub, rocksdb, stew, tempfile }:

buildNimPackage rec {
  pname = "rocksdb";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "status-im";
    repo = "nim-${pname}";
    rev = "5b1307cb1f4c85bb72ff781d810fb8c0148b1183";
    hash = "sha256-gjMCB9kpWVi9Qv73/jhoAYw857OmQpry//bDQCtyJo0=";
  };
  buildInputs = [ stew tempfile ];
  propagatedBuildInputs = [ rocksdb ];
  doCheck = false;
  meta = with lib;
    src.meta // {
      description = "Nim wrapper for RocksDB";
      maintainers = [ maintainers.ehmry ];
    };
}
