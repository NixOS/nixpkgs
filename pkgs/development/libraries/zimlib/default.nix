{ stdenv, fetchgit, automake, autoconf, libtool, lzma }:

stdenv.mkDerivation {
  name = "zimlib";
  version = "20150710";
  src = fetchgit {
    url = https://gerrit.wikimedia.org/r/p/openzim.git;
    rev = "165eab3e154c60b5b6436d653dc7c90f56cf7456";
    sha256 = "076ixsq4lis0rkk7p049g02bidc7bggl9kf2wzmgmsnx396mqymf";
  };
  buildInputs = [ automake autoconf libtool lzma ];
  setSourceRoot = "cd openzim-*/zimlib; export sourceRoot=`pwd`";
  preConfigurePhases = [ "./autogen.sh" ];

  meta = {
    description = "Library for reading and writing ZIM files (file format for storing Web content offline)";
    homepage =  http://www.openzim.org/wiki/Zimlib;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ robbinch ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
