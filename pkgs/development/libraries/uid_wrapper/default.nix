{ stdenv, fetchgit, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "uid_wrapper-1.1.0";

  src = fetchgit {
    url = "git://git.samba.org/uid_wrapper.git";
    rev = "refs/tags/${name}";
    sha256 = "1wb71lliw56pmks3vm9m3ndf8hqnyw9iyppy1nyl80msi4ssq5jj";
  };

  buildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "a wrapper for the user, group and hosts NSS API";
    homepage = "https://git.samba.org/?p=uid_wrapper.git;a=summary";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
