{ stdenv, fetchgit, autoreconfHook, boost, libevent, double_conversion, glog
, google-gflags, python, libiberty }:

stdenv.mkDerivation rec {
  name = "folly-12";

  src = fetchgit {
    url = "https://github.com/facebook/folly";
    rev = "8d3b079a75fe1a8cf5811f290642b4f494f13822";
    sha256 = "005fa202aca29c3a6757ae3bb050a6e4e5e773a1439f5803257a5f9e3cc9bdb6";
  };

  buildInputs = [ libiberty boost.lib libevent double_conversion glog google-gflags ];

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
