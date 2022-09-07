{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, reuse
}:

stdenv.mkDerivation {
  pname = "zix";
  version = "unstable-2022-09-08";

  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = "zix";
    # the repo doesn't have tags
    rev = "afc6ef7e54988fd68f33df21ec2a220e6bfc49f4";
    hash = "sha256-JW0D1sfyeE2/RzyX1iZ73xGFp/6WE5CgaUqstlh1yMk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    reuse # this shouldn't be required, but it is...
  ];

  mesonFlags = [ "-Dbenchmarks=disabled" ];

  meta = with lib; {
    homepage = "http://drobilla.net/software/zix";
    description = "A lightweight C99 portability and data structure library";
    license = licenses.isc;
    maintainers = [ maintainers.zseri ];
    platforms = platforms.unix;
  };
}
