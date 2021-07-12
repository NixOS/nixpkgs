{ lib, stdenv, fetchFromGitHub, zlib, curl, expat, fuse, openssl
, autoreconfHook, python3, libiconv
}:

stdenv.mkDerivation rec {
  version = "3.7.19";
  pname = "afflib";

  src = fetchFromGitHub {
    owner = "sshock";
    repo = "AFFLIBv3";
    rev = "v${version}";
    sha256 = "1qs843yi33yqbp0scqirn753lxzg762rz6xy2h3f8f77fijqj2qb";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib curl expat openssl python3 ]
    ++ lib.optionals (with stdenv; isLinux || isDarwin) [ fuse ]
    ++ lib.optionals stdenv.isDarwin [ libiconv ];

  meta = {
    homepage = "http://afflib.sourceforge.net/";
    description = "Advanced forensic format library";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsdOriginal;
    maintainers = [ lib.maintainers.raskin ];
    inherit version;
    downloadPage = "https://github.com/sshock/AFFLIBv3/tags";
  };
}
