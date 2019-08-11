{ fetchFromGitHub, stdenv }:

stdenv.mkDerivation rec {
  name = "crypto++-${version}";
  majorVersion = "5.6";
  version = "${majorVersion}.5";

  src = fetchFromGitHub {
    owner = "weidai11";
    repo = "cryptopp";
    rev = "CRYPTOPP_5_6_5";
    sha256 = "1yk7jyf4va9425cg05llskpls2jm7n3jwy2hj5jm74zkr4mwpvl7";
  };

  patches = stdenv.lib.concatLists [
    (stdenv.lib.optional (stdenv.hostPlatform.system != "i686-cygwin") ./dll.patch)
    (stdenv.lib.optional stdenv.hostPlatform.isDarwin ./GNUmakefile-darwin.patch)
  ];


  configurePhase = ''
      sed -i GNUmakefile \
        -e 's|-march=native|-fPIC|g' \
        -e '/^CXXFLAGS =/s|-g ||'
  '';

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [ "libcryptopp.so" ];
  installFlags = [ "LDCONF=true" ];

  doCheck = true;
  checkPhase = "LD_LIBRARY_PATH=`pwd` make test";

  # prefer -fPIC and .so to .a; cryptotest.exe seems superfluous
  postInstall = ''
    rm "$out"/lib/*.a -r "$out/bin"
    ln -sf "$out"/lib/libcryptopp.so.${version} "$out"/lib/libcryptopp.so.${majorVersion}
  '';

  meta = with stdenv.lib; {
    description = "Crypto++, a free C++ class library of cryptographic schemes";
    homepage = http://cryptopp.com/;
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
