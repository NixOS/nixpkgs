{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  json_c,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ucode";
  version = "0.0.20250529";

  src = fetchFromGitHub {
    owner = "jow-";
    repo = "ucode";
    rev = "v${finalAttrs.version}";
    hash = "sha256-V8WGd4rSuCtGIA5oTfnagp0Dmh5FNG87/MJSeILtbM4=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/jow-/ucode/commit/4d81e6c13506599261208786cfe4ee068f346dcd.patch";
      hash = "sha256-RZhD422ue00bqam4n7jAynPDJdOzOFJnf34YbT2wH/s=";
    })
    (fetchpatch {
      url = "https://github.com/jow-/ucode/commit/a7ead3169ebf355e66b399aca1dd3a5ce29e1e5b.patch";
      hash = "sha256-sc+jSAlix1jE9Cb4MMuqI7VHG6h+zpCL7UZ84awOL6M=";
    })
    # fix build w/ glibc-2.44
    (fetchpatch {
      url = "https://github.com/jow-/ucode/commit/beafcff845fcdbb46308ee54422661e80300079d.patch";
      hash = "sha256-JcBk8kJHDlHLRuVR2fmsSfWqVmbFZMPF16+nPp6QFf4=";
    })
  ];

  buildInputs = [
    json_c
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = {
    description = "JavaScript-like language with optional templating";
    homepage = "https://github.com/jow-/ucode";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mkg20001 ];
  };
})
