{ stdenv, fetchFromGitHub, autoreconfHook, boost, libevent, double_conversion, glog
, google-gflags, python, libiberty, openssl }:

stdenv.mkDerivation rec {
  version = "0.22.0";
  name = "folly-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "12p7vbx73jmhf772nbqvd8imw4ihpi16cw6cwxq459r7qds4n0ca";
  };

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
    # 32bit is not supported: https://github.com/facebook/folly/issues/103
    platforms = [ "x86_64-linux" ];
    maintainers = maintainers.abbradar;
  };
}
