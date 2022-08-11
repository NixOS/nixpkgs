{ lib
, stdenv
, fetchFromSourcehut
, qbe
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "harec";
  version = "unstable-2022-07-02";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "harec";
    rev = "56359312644f76941de1878d33a1a0b840be8056";
    hash = "sha256-8SFYRJSvX8hmsHBgaLUfhLUV7d54im22ETZds1eASc4=";
  };

  nativeBuildInputs = [
    qbe
  ];

  buildInputs = [
    qbe
  ];

  # TODO: report upstream
  hardeningDisable = [ "fortify" ];

  strictDeps = true;

  doCheck = true;

  meta = with lib; {
    homepage = "http://harelang.org/";
    description = "Bootstrapping Hare compiler written in C for POSIX systems";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ AndersonTorres ];
    # The upstream developers do not like proprietary operating systems; see
    # https://harelang.org/platforms/
    platforms = with platforms;
      lib.intersectLists (freebsd ++ linux) (aarch64 ++ x86_64 ++ riscv64);
    badPlatforms = with platforms; darwin;
  };
})
