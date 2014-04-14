{ fetchurl, stdenv, automake, libtool, autoconf, glibc }:

let version = "0.11.19";
in
stdenv.mkDerivation {
  name = "libuv-${version}";
  
  src = fetchurl {
    url = "http://libuv.org/dist/v${version}/libuv-v${version}.tar.gz";
    sha256 = "1brx0dwvw5nc6fmz5ji88l3xp7rjgpkf2yypwdjd8n279hwcpalb";
  };

  buildInputs = [ automake libtool autoconf glibc ];

  preConfigure = "sh autogen.sh";
  configureFlags = "--enable-shared --enable-static";

  NIX_CFLAGS_COMPILE = "-fPIC";

  # a file called "libtool" is being created that tries to run 
  # ldconfig with a bad PATH.
  preInstall = ''
    sed -i "s|finish_cmds=\".* ldconfig|finish_cmds=\"${glibc}/sbin/ldconfig|" libtool
  '';

  postInstall = ''
    make libuv.pc
    mkdir -p $out/lib/pkgconfig
    cp libuv.pc $out/lib/pkgconfig
  '';

  meta = {
    description = "Cross-platform asychronous I/O";
    homepage = http://libuv.org;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.emery ];
  };
}