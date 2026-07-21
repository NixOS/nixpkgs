{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libgcrypt,
  libcpr,
  libargs,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zsync2";
  version = "2.0.0-alpha-1-20250926";

  src = fetchFromGitHub {
    owner = "AppImageCommunity";
    repo = "zsync2";
    rev = finalAttrs.version;
    hash = "sha256-dbIe47cDaQJAOiHcLRwEbLgvrDUHOnPkYqDbkX74gZk=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'VERSION "2.0.0-alpha-1"' 'VERSION "${finalAttrs.version}"' \
      --replace-fail 'git rev-parse --short HEAD' 'bash -c "echo unknown"' \
      --replace-fail '<local dev build>' '<nixpkgs build>' \
      --replace-fail 'env LC_ALL=C date -u "+%Y-%m-%d %H:%M:%S %Z"' 'bash -c "echo 1970-01-01 00:00:01 UTC"'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libgcrypt
    libcpr
    libargs
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_CPR" true)
    (lib.cmakeBool "USE_SYSTEM_ARGS" true)
  ];

  env.NIX_CFLAGS_COMPILE = "-lz -Wno-error=incompatible-pointer-types";

  meta = {
    description = "Rewrite of the advanced file download/sync tool zsync";
    homepage = "https://github.com/AppImageCommunity/zsync2";
    license = lib.licenses.artistic2;
    mainProgram = "zsync2";
    maintainers = with lib.maintainers; [ aleksana ];
    # macro only supports linux as of now
    # src/zsclient.cpp#L460
    platforms = lib.platforms.linux;
  };
})
