{ stdenv, fetchFromGitHub, zlib, curl, expat, fuse, openssl
, autoreconfHook, python3
}:

stdenv.mkDerivation rec {
  version = "3.7.18";
  pname = "afflib";

  src = fetchFromGitHub {
    owner = "sshock";
    repo = "AFFLIBv3";
    rev = "v${version}";
    sha256 = "0963gw316p4nyxa9zxmgif29p8i99k898av2g78g28dxafqj3w8c";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib curl expat fuse openssl python3 ];

  meta = {
    homepage = http://afflib.sourceforge.net/;
    description = "Advanced forensic format library";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsdOriginal;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    inherit version;
    downloadPage = "https://github.com/sshock/AFFLIBv3/tags";
  };
}
