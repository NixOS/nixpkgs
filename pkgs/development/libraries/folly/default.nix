{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, boost, libevent, double_conversion, glog
, google-gflags, python, libiberty, openssl }:

stdenv.mkDerivation rec {
  name = "folly-${version}";
  version = "2016-04-29";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "b31eb722e444ab0293a73fe9de3f94e657ca6de9";
    sha256 = "0s95y0wnz4xbrkzbiksnb0n0d0qrkcsbssznng57kwlq8jlfka24";
  };

  nativeBuildInputs = [ autoreconfHook python ];
  buildInputs = [ libiberty boost libevent double_conversion glog google-gflags openssl ];

  postPatch = "cd folly";
  preBuild = ''
    patchShebangs build
  '';

  configureFlags = [ "--with-boost-libdir=${boost.lib}/lib" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An open-source C++ library developed and used at Facebook";
    homepage = https://github.com/facebook/folly;
    license = licenses.mit;
    # 32bit is not supported: https://github.com/facebook/folly/issues/103
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
