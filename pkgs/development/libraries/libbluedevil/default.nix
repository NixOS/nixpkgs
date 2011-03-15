{ stdenv, fetchgit, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "libbluedevil-20110304";

  src = fetchgit {
    url = git://anongit.kde.org/libbluedevil.git;
    rev = "b44537b1784528cacc62ab1d570c1565bd326b4f";
    sha256 = "15rx44dncg7hm2x04yz53ni4l1fpb40c3bma3pbvr7l2yd89x3sa";
  };

  buildInputs = [ cmake qt4 ];
}
