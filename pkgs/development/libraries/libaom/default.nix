{ stdenv, fetchgit, yasm, perl, cmake, pkgconfig, python3, writeText }:

stdenv.mkDerivation rec {
  name = "libaom-${version}";
  version = "1.0.0-errata1";

  src = fetchgit {
    url = "https://aomedia.googlesource.com/aom";
    rev	= "v${version}";
    sha256 = "090phh4jl9z6m2pwpfpwcjh6iyw0byngb2n112qxkg6a3gsaa62f";
  };

  nativeBuildInputs = [
    yasm perl cmake pkgconfig python3
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
