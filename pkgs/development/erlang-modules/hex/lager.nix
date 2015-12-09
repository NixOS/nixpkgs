{ buildHex, fetchurl, goldrush }:

buildHex {
  name = "lager";
  version = "3.0.2";
  src = fetchurl {
    url = "https://s3.amazonaws.com/s3.hex.pm/tarballs/lager-3.0.2.tar";
    sha256 = "0051zj6wfmmvxjn9q0nw8wic13nhbrkyy50cg1lcpdh17qiknzsj";
  };

  erlangDeps = [ goldrush ];
}
