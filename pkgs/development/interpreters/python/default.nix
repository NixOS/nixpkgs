{stdenv, fetchurl, zlib ? null, zlibSupport ? true}:

assert zlibSupport -> zlib != null;

stdenv.mkDerivation {
  name = "python-2.4.4";
  src = fetchurl {
    url = http://www.python.org/ftp/python/2.4.4/Python-2.4.4.tar.bz2;
    md5 = "0ba90c79175c017101100ebf5978e906";
  };
  buildInputs = [
    (if zlibSupport then zlib else null)
  ];
  inherit zlibSupport;
  configureFlags = "--enable-shared";
  
  libPrefix = "python2.4";
  
  postInstall = "
    ensureDir $out/nix-support
    cp ${./setup-hook.sh} $out/nix-support/setup-hook
    rm -rf $out/lib/python2.4/test
  ";
}
