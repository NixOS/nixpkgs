{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
}:

stdenv.mkDerivation {
  pname = "zix";
  version = "unstable-2022-09-08";

  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = "zix";
    # the repo doesn't have any releases yet
    rev = "a0293511f4d82d7cb800f568ff5c0d82be5c40c7";
    hash = "sha256-HxFIb/ux2YLVHrlgNOtxQsoQzCEPvAEG8UVXU2qN9Io=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  mesonFlags = [ "-Dbenchmarks=disabled" ];

  doCheck = true;

  meta = with lib; {
    homepage = "http://drobilla.net/software/zix";
    description = "A lightweight C99 portability and data structure library";
    license = licenses.isc;
    maintainers = [ maintainers.zseri ];
    platforms = platforms.unix;
  };
}
