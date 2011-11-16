{ stdenv, fetchurl, perl }:

let
  name = "openssl-1.0.0d";

  opensslCrossSystem = stdenv.lib.attrByPath [ "openssl" "system" ]
    (throw "openssl needs its platform name cross building" null)
    stdenv.cross;

  hurdGNUSourcePatch = fetchurl {
    url = http://patch-tracker.debian.org/patch/series/dl/openssl/1.0.0e-2.1/gnu_source.patch;
    sha256 = "0zp4x8bql92fbqywnigqfsfj2vvabb66wv6g6zgzh0y6js1ic4pn";
  };
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://www.openssl.org/source/${name}.tar.gz";
    sha256 = "1nr0cf6pf8i4qsnx31kqhiqv402xgn76yhjhlbdri8ma1hgislcj";
  };

  patches = stdenv.lib.optional stdenv.isDarwin ./darwin-arch.patch;

  buildNativeInputs = [ perl ];

  # On x86_64-darwin, "./config" misdetects the system as
  # "darwin-i386-cc".  So specify the system type explicitly.
  configureScript =
    if stdenv.system == "x86_64-darwin" then "./Configure darwin64-x86_64-cc" else "./config";

  configureFlags = "shared --libdir=lib";

  postInstall =
    ''
      # If we're building dynamic libraries, then don't install static
      # libraries.
      if [ -n "$(echo $out/lib/*.so)" ]; then
          rm $out/lib/*.a
      fi
    ''; # */

  crossAttrs = {
    preConfigure=''
      # It's configure does not like --build or --host
      export configureFlags="--libdir=lib --cross-compile-prefix=${stdenv.cross.config}- shared ${opensslCrossSystem}"
    '';

    patches = stdenv.lib.optionals (opensslCrossSystem == "hurd-x86") [
      # OpenSSL only defines _GNU_SOURCE on Linux, but we need it on GNU
      hurdGNUSourcePatch

      # Use the target settings from Debian's "debian-hurd-i386" target.
      # see http://patch-tracker.debian.org/patch/series/view/openssl/1.0.0e-2.1/debian-targets.patch
      # In particular, this sets the shared library extension properly so that
      # make install succeeds
      ./hurd-target.patch
    ];

    postInstall = ''
      # Openssl installs readonly files, which otherwise we can't strip.
      # This could at some stdenv hash change be put out of crossAttrs, too
      chmod -R +w $out

      # Remove references to perl, to avoid depending on it at runtime
      rm $out/bin/c_rehash $out/ssl/misc/CA.pl $out/ssl/misc/tsget
    '';
    configureScript = "./Configure";
  };

  meta = {
    homepage = http://www.openssl.org/;
    description = "A cryptographic library that implements the SSL and TLS protocols";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
