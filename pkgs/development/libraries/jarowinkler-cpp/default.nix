{ lib
, stdenv
, fetchFromGitHub
, cmake
, catch2_3
}:

stdenv.mkDerivation rec {
  pname = "jarowinkler-cpp";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "jarowinkler-cpp";
    rev = "v${version}";
    hash = "sha256-3/x0fyaDJTouBKbif0ALgMzht6HMEGHNw8g8zQlUcNk=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = lib.optionals doCheck [
    "-DJARO_WINKLER_BUILD_TESTING=ON"
  ];

  checkInputs = [
    catch2_3
  ];

  doCheck = true;

  meta = {
    description = "Fast Jaro and Jaro-Winkler distance";
    homepage = "https://github.com/maxbachmann/jarowinkler-cpp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.unix;
  };
}
