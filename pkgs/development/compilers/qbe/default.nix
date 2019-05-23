{ stdenv, fetchgit }:

stdenv.mkDerivation {
  pname = "qbe";
  version = "unstable-2019-05-15";

  src = fetchgit {
    url = "git://c9x.me/qbe.git";
    rev = "acc3af47330fd6610cf0fbdb28e9fbd05160888f";
    sha256 = "1c8ynqbakgz3hfdcyhwdmz7i1hnyd9m25f9y47sc21bvxwfrbzpi";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  meta = with stdenv.lib; {
    homepage = "https://c9x.me/compile/";
    description = "A small compiler backend written in C";
    maintainers = with maintainers; [ fgaz ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}

