{ boost, cmake, fetchFromGitHub, gtest, libpcap, openssl, stdenv }:

stdenv.mkDerivation rec {
  name = "libtins-${version}";
  version = "3.5";
  
  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "libtins";
    rev = "v${version}";
    sha256 = "00d1fxyg8q6djljm79ms69gcrsqxxksny3b16v99bzf3aivfss5x";
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
  checkPhase = "make tests && LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/lib make test";

  meta = with stdenv.lib; {
    description = "High-level, multiplatform C++ network packet sniffing and crafting library";
    homepage = https://libtins.github.io/;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with maintainers; [ fdns ];
    platforms = stdenv.lib.platforms.unix;
  };
}
