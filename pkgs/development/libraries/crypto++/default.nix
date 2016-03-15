{ fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  name = "crypto++-5.6.2";

  src = fetchurl {
    url = "mirror://sourceforge/cryptopp/cryptopp562.zip";
    sha256 = "0x1mqpz1v071cfrw4grbw7z734cxnpry1qh2b6rsmcx6nkyd5gsw";
  };

  patches = with stdenv;
    lib.optional (system != "i686-cygwin") ./dll.patch
    ++ lib.optional isDarwin ./GNUmakefile.patch;

  buildInputs = [ unzip ];

  sourceRoot = ".";

  configurePhase = let
    marchflags =
      if stdenv.isi686 then "-march=i686" else
      if stdenv.isx86_64 then "-march=nocona -mtune=generic" else
      "";
    in
    ''
      sed -i GNUmakefile \
        -e 's|-march=native|${marchflags} -fPIC|g' \
        -e '/^CXXFLAGS =/s|-g ||'
    '';

  enableParallelBuilding = true;

  makeFlags = "PREFIX=$(out)";
  buildFlags = "libcryptopp.so";

  doCheck = true;
  checkPhase = "LD_LIBRARY_PATH=`pwd` make test";

  # prefer -fPIC and .so to .a; cryptotest.exe seems superfluous
  postInstall = ''rm "$out"/lib/*.a -r "$out/bin" '';

  meta = with stdenv.lib; {
    description = "Crypto++, a free C++ class library of cryptographic schemes";
    homepage = http://cryptopp.com/;
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = [ ];
  };
}

