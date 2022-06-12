{ lib
, stdenv
, fetchFromGitHub
, cmake
, catch2
}:

stdenv.mkDerivation rec {
  pname = "rapidfuzz-cpp";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "rapidfuzz-cpp";
    rev = "v${version}";
    hash = "sha256-331iW0nu5MlxuKNTgMkRSASnglxn+hEWBhRMnw0lY2Y=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = lib.optionals doCheck [
    "-DRAPIDFUZZ_BUILD_TESTING=ON"
  ];

  checkInputs = [
    catch2
  ];

  # uses unreleased Catch2 version 3
  doCheck = false;

  meta = {
    description = "Rapid fuzzy string matching in C++ using the Levenshtein Distance";
    homepage = "https://github.com/maxbachmann/rapidfuzz-cpp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.unix;
  };
}
