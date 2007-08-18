{ stdenv, fetchurl, kernelHeaders 
,perl
, installLocales ? true
, profilingLibraries ? false
}:

stdenv.mkDerivation {
  name = "glibc-2.6.1-nptl";
  builder = ./builder.sh;

  src = 
	fetchurl {
		url = http://ftp.gnu.org/gnu/glibc/glibc-2.6.1.tar.bz2;
		sha256 = "08pcfsi9zpikjakljklks2ln3hn7544cr9br4kbh5kx27cy3mv9x";
	};

  patches = [ ./glibc-pwd.patch ./glibc-getcwd-param-MAX.patch ];

  inherit kernelHeaders installLocales;

  inherit (stdenv) is64bit;

  buildInputs=[perl];

  # `--with-tls --without-__thread' enables support for TLS but causes
  # it not to be used.  Required if we don't want to barf on 2.4
  # kernels.  Or something.
  configureFlags="--enable-add-ons
    --with-headers=${kernelHeaders}/include
    ${if profilingLibraries then "--enable-profile" else "--disable-profile"}";
}
