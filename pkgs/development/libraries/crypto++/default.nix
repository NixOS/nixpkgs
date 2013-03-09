{ fetchurl, stdenv, unzip, libtool }:

stdenv.mkDerivation rec {
  name = "crypto++-5.6.2";

  src = fetchurl {
    url = "mirror://sourceforge/cryptopp/cryptopp562.zip";
    sha256 = "0x1mqpz1v071cfrw4grbw7z734cxnpry1qh2b6rsmcx6nkyd5gsw";
  };

  patches = stdenv.lib.optional (stdenv.system != "i686-cygwin") ./dll.patch;

  buildInputs = [ unzip libtool ];

  # Unpack the thing in a subdirectory.
  unpackPhase = ''
    echo "unpacking Crypto++ to \`${name}' from \`$PWD'..."
    mkdir "${name}" && (cd "${name}" && unzip "$src")
    sourceRoot="$PWD/${name}"
  '';

  cxxflags = if stdenv.isi686 then "-march=i686" else
             if stdenv.isx86_64 then "-march=nocona -fPIC" else
             "";

  configurePhase = ''
    sed -i GNUmakefile \
      -e 's|-march=native|${cxxflags}|g' \
      -e 's|-mtune=native||g' \
      -e '/^CXXFLAGS =/s|-g -O2|-O3|'
  '';

  # I add what 'enableParallelBuilding' would add to the make call,
  # if we were using the generic build phase.
  buildPhase = ''
    make PREFIX="$out" all -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES
  '';

  # TODO: Installing cryptotest.exe doesn't seem to be necessary. We run
  # that binary during this build anyway to verify everything works.
  installPhase = ''
    mkdir "$out"
    make install PREFIX="$out"
  '';

  doCheck = true;
  checkPhase = "LD_LIBRARY_PATH=`pwd` make test";

  meta = {
    description = "Crypto++, a free C++ class library of cryptographic schemes";
    homepage = http://cryptopp.com/;
    license = "Boost 1.0";
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
