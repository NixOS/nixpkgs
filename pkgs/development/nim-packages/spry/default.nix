{ lib, buildNimPackage, fetchFromGitHub, rocksdb, snappy, spryvm, stew
, tempfile, ui }:

buildNimPackage rec {
  pname = "spry";
  version = "0.9.0";
  src = fetchFromGitHub {
    owner = "gokr";
    repo = pname;
    rev = "098da7bb34a9113d5db5402fecfc76b1c3fa3b36";
    hash = "sha256-PfWBrG2Z16tLgcN8JYpHaNMysBbbYX812Lkgk0ItMwE=";
  };
  buildInputs = [ rocksdb snappy spryvm stew tempfile ui ];
  patches = [ ./nil.patch ./python.patch ];
  meta = with lib;
    src.meta // {
      description =
        "A Smalltalk and Rebol inspired language implemented as an AST interpreter in Nim";
      license = [ licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
