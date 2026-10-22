{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zzuf";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "samhocevar";
    repo = "zzuf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yYpO1K9pVp+Fki0Bn5OHI4xhGGJ2yYC7U00M10PQIVI=";
  };

  patches = [
    # fix build with gcc14
    # https://src.fedoraproject.org/rpms/zzuf/c/998c7e5e632ea4c635a53437a01bfb48cbd744ac
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/zzuf/raw/998c7e5e632ea4c635a53437a01bfb48cbd744ac/f/zzuf-zzat-c99.patch";
      hash = "sha256-pQQzwsIjKg+9g+dnhFGn2PUlxHlQ5Mj+e4a1D1k2oEo=";
    })
    # https://src.fedoraproject.org/rpms/zzuf/c/ca7e406989e7ff461600084f2277ad15a8c00058
    ./zzuf-glibc.patch
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  meta = {
    description = "Transparent application input fuzzer";
    homepage = "http://caca.zoy.org/wiki/zzuf";
    license = lib.licenses.wtfpl;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lihop ];
  };
})
