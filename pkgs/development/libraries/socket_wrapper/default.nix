{ stdenv, fetchgit, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "socket_wrapper-1.1.3";

  src = fetchgit {
    url = "git://git.samba.org/socket_wrapper.git";
    rev = "refs/tags/${name}";
    sha256 = "0b3sfjy7418gg52qkdblfi5x57g4m44n7434xhacz9isyl5m52vn";
  };

  buildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "a library passing all socket communications through unix sockets";
    homepage = "https://git.samba.org/?p=socket_wrapper.git;a=summary";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
