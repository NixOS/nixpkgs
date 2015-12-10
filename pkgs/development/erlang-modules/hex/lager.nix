{ buildHex, goldrush }:

buildHex {
  name = "lager";
  version = "3.0.2";
  sha256 = "0051zj6wfmmvxjn9q0nw8wic13nhbrkyy50cg1lcpdh17qiknzsj";
  erlangDeps = [ goldrush ];
}
