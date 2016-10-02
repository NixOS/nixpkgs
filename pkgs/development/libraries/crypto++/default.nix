{ fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  name = "crypto++-${version}";
  majorVersion = "5.6";
  version = "${majorVersion}.4";

  src = fetchurl {
    url = "mirror://sourceforge/cryptopp/cryptopp564.zip";
    sha256 = "1msar24a38rxzq0xgmjf09hzaw2lv6s48vnbbhfrf5awn1vh6hxy";
  };

  patches = with stdenv;
    lib.optional (system != "i686-cygwin") ./dll.patch
    ++ lib.optional isDarwin ./GNUmakefile-darwin.patch;

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
