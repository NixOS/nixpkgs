{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkgconfig, boost, libevent
, double-conversion, glog, google-gflags, python, libiberty, openssl }:

stdenv.mkDerivation rec {
  name = "folly-${version}";
  version = "2018.06.18.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "0698wazz99wzfbz29jgkl4rlakypg3v2cnsjg9a0yq83a4y038p7";
  };

  nativeBuildInputs = [ autoreconfHook python pkgconfig ];
  buildInputs = [ libiberty boost libevent double-conversion glog google-gflags openssl ];

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
