{ stdenv
, lib
, fetchFromGitHub
, cmake
, gd
}:

stdenv.mkDerivation rec {
  pname = "libansilove";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "ansilove";
    repo = pname;
    rev = version;
    hash = "sha256-5ieahoxxT+7O47ZNP0hRzUOSCg9ayTqDq0soMhmVNpk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gd ];

  meta = with lib; {
    homepage = "https://www.ansilove.org";
    description = "Library for converting ANSI, ASCII, and other formats to PNG";
    license = licenses.bsd2;
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
