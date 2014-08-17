{ stdenv, fetchgit, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "1.2.20";
  name = "libtar-${version}";
  
  # Maintenance repo for libtar (Arch Linux uses this)
  src = fetchgit {
    url = "git://repo.or.cz/libtar.git";
    rev = "refs/tags/v${version}";
    sha256 = "1pjsqnqjaqgkzf1j8m6y5h76bwprffsjjj6gk8rh2fjsha14rqn9";
  };

  buildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "C library for manipulating POSIX tar files";
    homepage = http://www.feep.net/libtar/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
