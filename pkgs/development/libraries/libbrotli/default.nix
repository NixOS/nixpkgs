{stdenv, fetchFromGitHub, autoconf, automake, libtool, brotliUnstable}:

stdenv.mkDerivation rec {
  name = "libbrotli-20160120";
  version = "53d53e8";

  src = fetchFromGitHub {
    owner = "bagder";
    repo = "libbrotli";
    rev = "53d53e8d9c0d37398d37bac2e7a7aa20b0025e9e";
    sha256 = "10r4nx6n1r54f5cjck5mmmsj7bkasnmmz7m84imhil45q73kzd4m";
  };

  buildInputs = [autoconf automake libtool];
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
