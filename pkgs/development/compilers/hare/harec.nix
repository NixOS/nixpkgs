{ lib
, stdenv
, fetchFromSourcehut
, qbe
}:

stdenv.mkDerivation rec {
  pname = "harec";
  version = "unstable-2022-06-20";

  src = fetchFromSourcehut {
    name = pname + "-src";
    owner = "~sircmpwn";
    repo = pname;
    rev = "2eccbc4b959a590dda91143c8487edda841106d9";
    hash = "sha256-pwy7cNxAqIbhx9kpcjfgk7sCEns9oA6zhKSQJdHLZCM=";
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
}
