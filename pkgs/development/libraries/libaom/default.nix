{ stdenv, fetchgit, yasm, perl, cmake, pkgconfig, python3, writeText }:

stdenv.mkDerivation rec {
  name = "libaom-${version}";
  version = "1.0.0";

  src = fetchgit {
    url = "https://aomedia.googlesource.com/aom";
    rev	= "v${version}";
    sha256 = "07h2vhdiq7c3fqaz44rl4vja3dgryi6n7kwbwbj1rh485ski4j82";
  };

  nativeBuildInputs = [
    yasm perl cmake pkgconfig python3
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  preConfigure = ''
    # build uses `git describe` to set the build version
    cat > $NIX_BUILD_TOP/git << "EOF"
    #!${stdenv.shell}
    echo v${version}
    EOF
    chmod +x $NIX_BUILD_TOP/git
    export PATH=$NIX_BUILD_TOP:$PATH
  '';

  meta = with stdenv.lib; {
    description = "AV1 Bitstream and Decoding Library";
    homepage    = https://aomedia.org/av1-features/get-started/;
    maintainers = with maintainers; [ kiloreux ];
    platforms   = platforms.all;
    license = licenses.bsd2;
  };
}
