{ stdenv, fetchFromGitHub, autoreconfHook, libtool, brotli }:

stdenv.mkDerivation rec {
  name = "libbrotli-${version}";
  version = "1.0.1.2017-10-30";

  src = fetchFromGitHub {
    owner = "bagder";
    repo = "libbrotli";
    rev = "a90f3a40bf597fe0bec4ddc4651bbc8470055b6f";
    sha256 = "05zkgbnsmnn34gryk1kz6r46jgkbd2jhx2brfzhza7ddwhc3dr1j";
  };

  nativeBuildInputs = [ autoreconfHook libtool ];

  preAutoreconf = ''
    cp -r ${brotli.src}/* brotli/
    chmod -R +700 brotli
    mkdir m4
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
