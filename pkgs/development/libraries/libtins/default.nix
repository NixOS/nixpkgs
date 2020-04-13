{ boost, cmake, fetchFromGitHub, gtest, libpcap, openssl, stdenv }:

stdenv.mkDerivation rec {
  pname = "libtins";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gv661gdf018zk1sr6fnvcmd5akqjihs4h6zzxv6881v6yhhglrz";
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
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD${placeholder "out"}/lib
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}$PWD${placeholder "out"}/lib
  '';
  checkTarget = "tests test";

  meta = with stdenv.lib; {
    description = "High-level, multiplatform C++ network packet sniffing and crafting library";
    homepage = "https://libtins.github.io/";
    changelog = "https://raw.githubusercontent.com/mfontanini/${pname}/v${version}/CHANGES.md";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with maintainers; [ fdns ];
    platforms = stdenv.lib.platforms.unix;
  };
}
