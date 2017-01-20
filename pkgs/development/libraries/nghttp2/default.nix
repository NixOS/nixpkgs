{ stdenv, fetchurl, pkgconfig

# Optional Dependencies
, openssl ? null, libev ? null, zlib ? null
, enableHpack ? false, jansson ? null
, enableAsioLib ? false, boost ? null
, enableGetAssets ? false, libxml2 ? null
, enableJemalloc ? false, jemalloc ? null
}:

assert enableHpack -> jansson != null;
assert enableAsioLib -> boost != null;
assert enableGetAssets -> libxml2 != null;
assert enableJemalloc -> jemalloc != null;

with { inherit (stdenv.lib) optional; };

stdenv.mkDerivation rec {
  name = "nghttp2-${version}";
  version = "1.17.0";

  # Don't use fetchFromGitHub since this needs a bootstrap curl
  src = fetchurl {
    url = "https://github.com/nghttp2/nghttp2/releases/download/v${version}/nghttp2-${version}.tar.bz2";
    sha256 = "7685b6717d205d3a251b7dd5e73a7ca5e643bc5c01f928b82bfeed30c243f28a";
  };

  outputs = [ "out" "dev" "lib" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl libev zlib ]
    ++ optional enableHpack jansson
    ++ optional enableAsioLib boost
    ++ optional enableGetAssets libxml2
    ++ optional enableJemalloc jemalloc;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://nghttp2.org/;
    description = "A C implementation of HTTP/2";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
