{ stdenv, fetchgit, zlib, curl, expat, fuse, openssl
, autoconf, automake, libtool, python
}:

stdenv.mkDerivation rec {
  version = "3.7.6";
  name = "afflib-${version}";

  src = fetchgit {
    url = "https://github.com/sshock/AFFLIBv3/";
    rev = "refs/tags/v${version}";
    sha256 = "11wpjbyja6cn0828sw3951s7dbly11abijk41my3cpy9wnvmiggh";
    name = "afflib-${version}-checkout";
  };

  buildInputs = [ zlib curl expat fuse openssl 
    libtool autoconf automake python
    ];

  preConfigure = ''
    libtoolize -f
    autoheader -f
    aclocal
    automake --add-missing -c 
    autoconf -f
  '';

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
