{ fetchurl, stdenv, unzip, libtool }:

stdenv.mkDerivation rec {
  name = "crypto++-5.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/cryptopp/cryptopp560.zip";
    sha256 = "1icbk50mr1sqycqbxbqg703m8aamz23ajgl22ychxdahz2sz08mm";
  };

  patches = [ ./pic.patch ]
    ++ stdenv.lib.optional (stdenv.system != "i686-cygwin") ./dll.patch;


  buildInputs = [ unzip ]

    # For some reason the makefile sets "AR = libtool" on Darwin.
    ++ stdenv.lib.optional (stdenv.system == "i686-darwin") libtool;

  # Unpack the thing in a subdirectory.
  unpackPhase = ''
    echo "unpacking Crypto++ to \`${name}' from \`$PWD'..."
    mkdir "${name}" && (cd "${name}" && unzip "$src")
    sourceRoot="$PWD/${name}"
  '';

  cxxflags = if stdenv.isi686 then "-march=i686" else
             if stdenv.isx86_64 then "-march=nocona" else
             "";

  configurePhase = ''
    sed -i GNUmakefile \
      -e 's|-march=native|${cxxflags}|g' \
      -e 's|-mtune=native||g' \
      -e '/^CXXFLAGS =/s|-g -O2|-O3|'
  '';

  # Deal with one of the crappiest build system around there.
  buildPhase = ''
    # These guys forgot a file or something.
    : > modexppc.cpp

    make PREFIX="$out" all cryptopp.dll
  '';

  # TODO: Installing cryptotest.exe doesn't seem to be necessary. We run
  # that binary during this build anyway to verify everything works.
  installPhase = ''
    mkdir "$out"
    make install PREFIX="$out"
    cp -v cryptopp.dll "$out/lib/libcryptopp.so"
  '';

  doCheck = true;
  checkPhase = "make test";

  meta = {
    description = "Crypto++, a free C++ class library of cryptographic schemes";
    homepage = http://cryptopp.com/;
    license = "Public Domain";
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
