{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, gtest
, pkg-config
, zlib
, bzip2
, xz
, zstd
, openssl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minizip-ng";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "zlib-ng";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    sha256 = "sha256-m/zSVx8vYzLA23Cusd1p/ZSGd1mV3gM6UqDnmEXqpq4=";
  };

  patches = [
    (fetchpatch {
      name = "find-system-gtest.patch";
      url = "https://github.com/zlib-ng/minizip-ng/commit/be23c8d3b7e2cb5ba619e60517cad277ee510fb7.patch";
      sha256 = "sha256-azwrGj6kgTyTepGAmOlxDOFOwJKQE5J2bwUIn6sgKUY=";
    })

    # otherwise signing unit tests fail
    (fetchpatch {
      name = "disable-mz-signing-by-default.patch";
      url = "https://github.com/zlib-ng/minizip-ng/commit/60649ada97581afc0bc2fffc50ce402ff1e6df5d.patch";
      sha256 = "sha256-bHGM4H8RPYkfAjxcS1bPohR9IFOFT0Mx4Mg34UnnD+w=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ zlib bzip2 xz zstd openssl ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
    "-DMZ_OPENSSL=ON"
    "-DMZ_BUILD_TESTS=${if finalAttrs.doCheck then "ON" else "OFF"}"
    "-DMZ_BUILD_UNIT_TESTS=${if finalAttrs.doCheck then "ON" else "OFF"}"
  ] ++ lib.optionals stdenv.isDarwin [
    # missing header file
    "-DMZ_LIBCOMP=OFF"
  ];

  postInstall = ''
    # make lib findable as libminizip-ng even if compat is enabled
    for ext in so dylib a ; do
      if [ -e $out/lib/libminizip.$ext ] && [ ! -e $out/lib/libminizip-ng.$ext ]; then
        ln -s $out/lib/libminizip.$ext $out/lib/libminizip-ng.$ext
      fi
    done
    if [ ! -e $out/include/minizip-ng ]; then
      ln -s $out/include $out/include/minizip-ng
    fi
  '';

  doCheck = stdenv.buildPlatform == stdenv.hostPlatform;
  nativeCheckInputs = [ gtest ];
  enableParallelChecking = false;

  meta = with lib; {
    description = "Fork of the popular zip manipulation library found in the zlib distribution";
    homepage = "https://github.com/zlib-ng/minizip-ng";
    license = licenses.zlib;
    maintainers = with maintainers; [ gebner ris ];
    platforms = platforms.unix;
  };
})
