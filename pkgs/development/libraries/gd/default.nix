{ lib
, stdenv
, fetchurl
, fetchpatch
, autoconf
, automake
, pkg-config
, zlib
, libpng
, libjpeg
, libwebp
, libtiff
, withXorg ? true
, libXpm
, libavif
, fontconfig
, freetype
}:

stdenv.mkDerivation rec {
  pname = "gd";
  version = "2.3.3";

  src = fetchurl {
    url = "https://github.com/libgd/libgd/releases/download/${pname}-${version}/libgd-${version}.tar.xz";
    sha256 = "0qas3q9xz3wgw06dm2fj0i189rain6n60z1vyq50d5h7wbn25s1z";
  };

  patches = [
    (fetchpatch { # included in > 2.3.3
      name = "restore-GD_FLIP.patch";
      url = "https://github.com/libgd/libgd/commit/f4bc1f5c26925548662946ed7cfa473c190a104a.diff";
      sha256 = "XRXR3NOkbEub3Nybaco2duQk0n8vxif5mTl2AUacn9w=";
    })
  ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--enable-gd-formats"
  ]
    # -pthread gets passed to clang, causing warnings
    ++ lib.optional stdenv.isDarwin "--enable-werror=no";

  nativeBuildInputs = [ autoconf automake pkg-config ];

  buildInputs = [ zlib freetype libpng libjpeg libwebp libtiff libavif ]
    ++ lib.optionals withXorg [ fontconfig libXpm ];

  outputs = [ "bin" "dev" "out" ];

  postFixup = ''
    moveToOutput "bin/gdlib-config" $dev
  '';

  enableParallelBuilding = true;

  doCheck = false; # fails 2 tests

  meta = with lib; {
    homepage = "https://libgd.github.io/";
    description = "Dynamic image creation library";
    license = licenses.free; # some custom license
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
