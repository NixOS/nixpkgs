{ stdenv, fetchFromGitHub, autoconf, automake, libtool, brotliUnstable }:

stdenv.mkDerivation rec {
  name = "libbrotli-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "bagder";
    repo = "libbrotli";
    rev = name;
    sha256 = "0apd3hpy3vaa7brkv8v0xwz05zbd5xv86rcbkwns4x39klba3m3y";
  };

  nativeBuildInputs = [ autoconf automake libtool ];

  preConfigure = ''
    cp -r ${brotliUnstable.src}/* brotli/
    chmod -R +700 brotli
    mkdir m4
    autoreconf --install --force --symlink
  '';

  meta = with stdenv.lib; {
    description = "Meta project to build libraries from the brotli source code";
    longDescription = ''
      Wrapper scripts and code around the brotli code base.
      Builds libraries out of the brotli decode and encode sources. Uses autotools.
      'brotlidec' is the library for decoding, decompression
      'brotlienc' is the library for encoding, compression
    '';

    homepage = https://github.com/bagder/libbrotli;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [];
  };
}
