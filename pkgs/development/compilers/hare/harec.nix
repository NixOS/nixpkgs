{ lib
, stdenv
, fetchFromSourcehut
, qbe
}:

stdenv.mkDerivation rec {
  pname = "harec";
  version = "0.pre+date=2022-04-26";

  src = fetchFromSourcehut {
    name = pname + "-src";
    owner = "~sircmpwn";
    repo = pname;
    rev = "e5fb5176ba629e98ace5fcb3aa427b2c25d8fdf0";
    hash = "sha256-sqt3q6sarzrpyJ/1QYM1WTukrZpflAmAYq6pQwAwe18=";
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
