{ stdenv, fetchFromGitHub, zlib, curl, expat, fuse, openssl
, autoreconfHook, python
}:

stdenv.mkDerivation rec {
  version = "3.7.16";
  name = "afflib-${version}";

  src = fetchFromGitHub {
    owner = "sshock";
    repo = "AFFLIBv3";
    rev = "v${version}";
    sha256 = "0piwkmg7jn64h57cjf5cybyvyqxj2k752g9vrf4ycds7nhvvbnb6";
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
