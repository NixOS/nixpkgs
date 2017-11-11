{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkgconfig, boost, libevent
, double_conversion, glog, google-gflags, python, libiberty, openssl }:

stdenv.mkDerivation rec {
  name = "folly-${version}";
  version = "2017.11.06.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "11sn4gwqw94ygc2s4bzqy5k67v3rr20gy375brdcrl5rv0r2hhc0";
  };

  nativeBuildInputs = [ autoreconfHook python pkgconfig ];
  buildInputs = [ libiberty boost libevent double_conversion glog google-gflags openssl ];

  postPatch = "cd folly";
  preBuild = ''
    patchShebangs build
  '';

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An open-source C++ library developed and used at Facebook";
    homepage = https://github.com/facebook/folly;
    license = licenses.asl20;
    # 32bit is not supported: https://github.com/facebook/folly/issues/103
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
