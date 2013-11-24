{ stdenv, fetchurl
, zlib, zlibSupport ? true
, openssl, opensslSupport ? true
, gdbm, gdbmSupport ? true
, ncurses, readline, cursesSupport ? false
, groff, docSupport ? false
}:

let
  op = stdenv.lib.optional;
  ops = stdenv.lib.optionals;
in

stdenv.mkDerivation rec {
  version = with passthru; "${majorVersion}.${minorVersion}-p${patchLevel}";
  
  name = "ruby-${version}";
  
  src = fetchurl {
    url = "http://cache.ruby-lang.org/pub/ruby/1.8/${name}.tar.gz";
    sha256 = "0g2dsn8lmiqwqsp13ryzi97qxr7742v5l7v506x6wq9aiwpk42p6";
  };

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  NROFF = "${groff}/bin/nroff";

  buildInputs = (ops cursesSupport [ ncurses readline ] )
    ++ (op docSupport groff )
    ++ (op zlibSupport zlib)
    ++ (op opensslSupport openssl)
    ++ (op gdbmSupport gdbm);
    
  configureFlags = ["--enable-shared" "--enable-pthread"];

  installFlags = stdenv.lib.optionalString docSupport "install-doc";
  # Bundler tries to create this directory
  postInstall = "mkdir -pv $out/${passthru.gemPath}";

  meta = {
    license = "Ruby";
    homepage = "http://www.ruby-lang.org/en/";
    description = "The Ruby language";
  };

  passthru = rec {
    majorVersion = "1.8";
    minorVersion = "7";
    patchLevel = "371";
    libPath = "lib/ruby/${majorVersion}";
    gemPath = "lib/ruby/gems/${majorVersion}";
  };
}
