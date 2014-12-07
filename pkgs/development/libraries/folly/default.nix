{ stdenv, fetchgit, autoreconfHook, boost, libevent, double_conversion, glog
, google-gflags, python, libiberty, openssl }:

stdenv.mkDerivation rec {
  name = "folly-17";

  src = fetchgit {
    url = "https://github.com/facebook/folly";
    rev = "2c2d5777cd2551397a920007589fd3adba6cb7ab";
    sha256 = "13mfnv04ckkr2syigaaxrbaxmfiwqvn0a7fjxvdi6dii3fx81rsx";
  };

  patches = [ ./105.patch ];

  buildInputs = [ libiberty boost.lib libevent double_conversion glog google-gflags openssl ];

  nativeBuildInputs = [ autoreconfHook python boost ];

  postUnpack = "sourceRoot=\${sourceRoot}/folly";
  preBuild = ''
    patchShebangs build
  '';

  configureFlags = [ "--with-boost-libdir=${boost.lib}/lib" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A YAML parser and emitter for C++";
    homepage = https://code.google.com/p/yaml-cpp/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = maintainers.abbradar;
  };
}
