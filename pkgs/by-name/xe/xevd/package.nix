{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  stdenv,
  gitUpdater,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xevd";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "mpeg5";
    repo = "xevd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+qC/BnP8o/kfl5ax+g1PohvXIJBL2gin/QZ9Gkvi0WU=";
  };

  patches = [
    (fetchpatch2 {
      name = "fix dangling pointer error";
      url = "https://github.com/mpeg5/xevd/commit/13b86a74e26df979dd1cc3a1cb19bf1ac828e197.patch";
      sha256 = "sha256-CeSfhN78ldooyZ9H4F2ex9wTBFXuNZdBcnLdk7GqDXI=";
    })
    (fetchpatch2 {
      name = "fix invalid comparison of c_buf in write_y4m_header ";
      url = "https://github.com/mpeg5/xevd/commit/e4ae0c567a6ec5e10c9f5ed44c61e4e3b6816c16.patch";
      sha256 = "sha256-9bG6hyIV/AZ0mRbd3Fc/c137Xm1i6NJ1IfuGadG0vUU=";
    })
  ];

  postPatch = ''
    echo v$version > version.txt
  '';

  nativeBuildInputs = [ cmake ];

  postInstall = ''
    ln $dev/include/xevd/* $dev/include/
  '';

  env.NIX_CFLAGS_COMPILE = toString [ "-lm" ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://github.com/mpeg5/xevd";
    description = "eXtra-fast Essential Video Decoder, MPEG-5 EVC";
    license = lib.licenses.bsd3;
    mainProgram = "xevd_app";
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.all;
    broken = !stdenv.hostPlatform.isx86;
  };
})
