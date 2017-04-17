{ stdenv, fetchFromGitHub, zlib, curl, expat, fuse, openssl
, autoreconfHook, python
}:

stdenv.mkDerivation rec {
  version = "3.7.15";
  name = "afflib-${version}";

  src = fetchFromGitHub {
    owner = "sshock";
    repo = "AFFLIBv3";
    rev = "v${version}";
    sha256 = "0ckg49m15lz5cxg0k12z2ys6v4smjr6l8bbazrvsqlm649gwd2bw";
  };

  buildInputs = [ zlib curl expat fuse openssl autoreconfHook python ];


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
