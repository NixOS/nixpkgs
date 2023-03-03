{ lib
, stdenv
, fetchFromSourcehut
, qbe
}:

stdenv.mkDerivation (self: {
  pname = "harec";
  version = "unstable-2023-02-08";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "harec";
    rev = "4730fa6b835f08c44bd7991cc8b264fbc27d752b";
    hash = "sha256-XOhZWdmkMAuXbj7svILJI3wI7RF9OAb/OE1uGel4/vE=";
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

  meta = {
    homepage = "http://harelang.org/";
    description = "Bootstrapping Hare compiler written in C for POSIX systems";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.AndersonTorres ];
    # The upstream developers do not like proprietary operating systems; see
    # https://harelang.org/platforms/
    platforms = with lib.platforms;
      lib.intersectLists (freebsd ++ linux) (aarch64 ++ x86_64 ++ riscv64);
    badPlatforms = lib.platforms.darwin;
  };
})
