{ stdenv, fetchgit, automake, autoconf, libtool, lzma }:

stdenv.mkDerivation {
  name = "zimlib";
  version = "20150710";
  src = fetchgit {
    url = https://gerrit.wikimedia.org/r/p/openzim.git;
    rev = "165eab3e154c60b5b6436d653dc7c90f56cf7456";
    sha256 = "0x0d3rx6zcc8k66nqkacmwdvslrz70h9bliqawzv90ribq3alb0q";
  };
  buildInputs = [ automake autoconf libtool lzma ];
  setSourceRoot = "cd openzim-*/zimlib; export sourceRoot=`pwd`";
  preConfigurePhases = [ "./autogen.sh" ];

  meta = {
    description = "Library for reading and writing ZIM files (file format for storing Web content offline)";
    homepage =  http://www.openzim.org/wiki/Zimlib;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ robbinch ];
  };
}
