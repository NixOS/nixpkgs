{ stdenv, fetchurl, apr, scons, openssl, aprutil, zlib, kerberos, pkgconfig, gnused }:

stdenv.mkDerivation rec {
  name = "serf-1.3.7";

  src = fetchurl {
    url = "http://serf.googlecode.com/svn/src_releases/${name}.tar.bz2";
    sha256 = "1bphz616dv1svc50kkm8xbgyszhg3ni2dqbij99sfvjycr7bgk7c";
  };

  buildInputs = [ apr scons openssl aprutil zlib ]
    ++ stdenv.lib.optional (!stdenv.isCygwin) kerberos
    ++ [ pkgconfig ];

  configurePhase = ''
    ${gnused}/bin/sed -e '/^env[.]Append(BUILDERS/ienv.Append(ENV={"PATH":os.environ["PATH"]})' -i SConstruct
    ${gnused}/bin/sed -e '/^env[.]Append(BUILDERS/ienv.Append(ENV={"NIX_CFLAGS_COMPILE":os.environ["NIX_CFLAGS_COMPILE"]})' -i SConstruct
    ${gnused}/bin/sed -e '/^env[.]Append(BUILDERS/ienv.Append(ENV={"NIX_LDFLAGS":os.environ["NIX_LDFLAGS"]})' -i SConstruct
  '';

  buildPhase = ''
    scons PREFIX="$out" OPENSSL="${openssl.dev}" ZLIB="${zlib.dev}" APR="$(echo "${apr.dev}"/bin/*-config)" \
        APU="$(echo "${aprutil.dev}"/bin/*-config)" CC="${
          if stdenv.cc.isClang then "clang" else "${stdenv.cc}/bin/gcc"
        }" ${
          if (stdenv.isDarwin || stdenv.isCygwin) then "" else "GSSAPI=\"${kerberos}\""
        }
  '';

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-L/usr/lib";

  installPhase = ''
    scons install
  '';

  meta = {
    description = "HTTP client library based on APR";
    license = stdenv.lib.licenses.asl20;
    maintainers = [stdenv.lib.maintainers.raskin];
    hydraPlatforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
