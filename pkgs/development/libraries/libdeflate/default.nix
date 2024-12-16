{
  lib,
  stdenv,
  fetchFromGitHub,
  fixDarwinDylibNames,
  pkgsStatic,
  cmake,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdeflate";
  version = "1.23";

  src = fetchFromGitHub {
    owner = "ebiggers";
    repo = "libdeflate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bucVkRgZdzLe2HFzIP+Trq4+FJ5kLYdIVNUiJ2f52zg=";
  };

  cmakeFlags = lib.optionals stdenv.hostPlatform.isStatic [ "-DLIBDEFLATE_BUILD_SHARED_LIB=OFF" ];

  nativeBuildInputs = [ cmake ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  passthru.tests = {
    static = pkgsStatic.libdeflate;
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    description = "Fast DEFLATE/zlib/gzip compressor and decompressor";
    license = licenses.mit;
    homepage = "https://github.com/ebiggers/libdeflate";
    changelog = "https://github.com/ebiggers/libdeflate/blob/v${finalAttrs.version}/NEWS.md";
    platforms = platforms.unix ++ platforms.windows;
    maintainers = with maintainers; [
      orivej
      kaction
    ];
    pkgConfigModules = [ "libdeflate" ];
  };
})
