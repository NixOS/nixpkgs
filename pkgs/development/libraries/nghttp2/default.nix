{ stdenv, fetchurl, pkgconfig

# Optional Dependencies
, openssl ? null, libev ? null, zlib ? null, jansson ? null, boost ? null
, libxml2 ? null, jemalloc ? null
}:

stdenv.mkDerivation rec {
  name = "nghttp2-${version}";
  version = "1.14.1";

  # Don't use fetchFromGitHub since this needs a bootstrap curl
  src = fetchurl {
    url = "https://github.com/nghttp2/nghttp2/releases/download/v${version}/nghttp2-${version}.tar.bz2";
    sha256 = "0d7sk3pfkajhkmcqa7zx4rjg1pkwqraxxs7bxbwbm67r8wwqw87j";
  };

  # Configure script searches for a symbol which does not exist in jemalloc on Darwin
  # Reported upstream in https://github.com/tatsuhiro-t/nghttp2/issues/233
  postPatch = if stdenv.isDarwin && jemalloc != null then ''
    substituteInPlace configure --replace "malloc_stats_print" "je_malloc_stats_print"
  '' else null;

  outputs = [ "out" "dev" "lib" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl libev zlib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://nghttp2.org/;
    description = "A C implementation of HTTP/2";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
