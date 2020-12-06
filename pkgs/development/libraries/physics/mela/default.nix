{ stdenv, fetchFromGitHub, gfortran }:

stdenv.mkDerivation rec {
  pname = "mela";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "vbertone";
    repo = "MELA";
    rev = version;
    sha256 = "01sgd4mwx4n58x95brphp4dskqkkx8434bvsr38r5drg9na5nc9y";
  };

  buildInputs = [ gfortran ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "a Mellin Evolution LibrAry";
    license     = licenses.gpl3;
    homepage    = "https://github.com/vbertone/MELA";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
