{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkgconfig, which, texinfo, guile, libssh }:
stdenv.mkDerivation rec {
  pname = "guile-ssh";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "artyom-poptsov";
    repo = pname;
    rev = "v${version}";
    sha256 = "054hd9rzfhb48gc1hw3rphhp0cnnd4bs5qmidy5ygsyvy9ravlad";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig which texinfo ];  # Which is probably a hack
  buildInputs = [ guile libssh ]; # Maybe use libssh2

  meta = with stdenv.lib; {
    description = "Provides access to the SSH protocol for GNU Guile";
    homepage = "https://github.com/artyom-poptsov/guile-ssh";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = platforms.unix;
  };
}
