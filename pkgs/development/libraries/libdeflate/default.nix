{ stdenv, lib, fetchFromGitHub, fetchpatch, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "libdeflate";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "ebiggers";
    repo = "libdeflate";
    rev = "v${version}";
    sha256 = "1hnn1yd9s5h92xs72y73izak47kdz070kxkw3kyz2d3az6brfdgh";
  };
  # Waiting for PR https://github.com/ebiggers/libdeflate/pull/135
  patches = lib.optional stdenv.hostPlatform.isStatic
  (fetchpatch {
    url = "https://github.com/ebiggers/libdeflate/pull/135/commits/030310477a9ec82a264f4009c9f3acf195a1af8a.patch";
    sha256 = "0wlqj0qbvp2b60a4mngkjhh5qwygfi5caayb4y5i2a8lpal4dsxf";
  });
  makeFlags = lib.optional stdenv.hostPlatform.isStatic [
    "DONTBUILD_SHARED_LIBS=1"
  ];

  postPatch = ''
    substituteInPlace Makefile --replace /usr/local $out
  '';

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  configurePhase = ''
    make programs/config.h
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Fast DEFLATE/zlib/gzip compressor and decompressor";
    license = licenses.mit;
    homepage = "https://github.com/ebiggers/libdeflate";
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
