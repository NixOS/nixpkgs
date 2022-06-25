{ lib
, stdenv
, fetchFromGitHub
, cmake
, catch2_3
}:

stdenv.mkDerivation rec {
  pname = "rapidfuzz-cpp";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "rapidfuzz-cpp";
    rev = "v${version}";
    hash = "sha256-Tf7nEMXiem21cvQHPnYnCvOOLg0KBBnNQDaYIcHcm2g=";
  };

  patches = lib.optionals doCheck [
    ./dont-fetch-project-options.patch
  ];

  postPatch = ''
    substituteInPlace test/CMakeLists.txt \
      --replace WARNINGS_AS_ERRORS ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = lib.optionals doCheck [
    "-DRAPIDFUZZ_BUILD_TESTING=ON"
  ];

  checkInputs = [
    catch2_3
  ];

  doCheck = true;

  meta = {
    description = "Rapid fuzzy string matching in C++ using the Levenshtein Distance";
    homepage = "https://github.com/maxbachmann/rapidfuzz-cpp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.unix;
  };
}
