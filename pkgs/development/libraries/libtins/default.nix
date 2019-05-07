{ boost, cmake, fetchFromGitHub, gtest, libpcap, openssl, stdenv }:

stdenv.mkDerivation rec {
  name = "libtins-${version}";
  version = "4.0";
  
  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "libtins";
    rev = "v${version}";
    sha256 = "13sdqad976j7gq2k1il6g51yxwr8rlqdkzf1kj9mzhihjq8541qs";
  };

  postPatch = ''
    rm -rf googletest
    cp -r ${gtest.src}/googletest googletest
    chmod -R a+w googletest
  '';

  nativeBuildInputs = [ cmake gtest ];
  buildInputs = [
    openssl
    libpcap
    boost
  ];

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--with-boost=${boost.dev}"
  ];

  enableParallelBuilding = true;
  doCheck = true;
  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/lib
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$PWD/lib
  '';
  checkTarget = "tests test";

  meta = with stdenv.lib; {
    description = "High-level, multiplatform C++ network packet sniffing and crafting library";
    homepage = https://libtins.github.io/;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with maintainers; [ fdns ];
    platforms = stdenv.lib.platforms.unix;
  };
}
