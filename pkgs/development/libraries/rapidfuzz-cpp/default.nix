{ lib
, stdenv
, fetchFromGitHub
, cmake
, catch2_3
}:

stdenv.mkDerivation rec {
  pname = "rapidfuzz-cpp";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "rapidfuzz-cpp";
    rev = "v${version}";
    hash = "sha256-c9ESzsDcoUw5XAEZDHdG8jazjI5Oyqic1gaT0qGQsbI=";
  };

  patches = [
    ./dont-fetch-project-options.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = lib.optionals doCheck [
    "-DRAPIDFUZZ_BUILD_TESTING=ON"
  ];

  CXXFLAGS = lib.optionals stdenv.cc.isClang [
    # error: no member named 'fill' in namespace 'std'
    "-include algorithm"
  ];

  checkInputs = [
    catch2_3
  ];

  doCheck = true;

  meta = {
    description = "Rapid fuzzy string matching in C++ using the Levenshtein Distance";
    homepage = "https://github.com/maxbachmann/rapidfuzz-cpp";
    changelog = "https://github.com/maxbachmann/rapidfuzz-cpp/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.unix;
  };
}
