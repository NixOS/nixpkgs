{ lib
, stdenv
, fetchFromGitHub
, cmake
, catch2_3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapidfuzz-cpp";
<<<<<<< HEAD
  version = "2.0.0";
=======
  version = "1.11.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "rapidfuzz-cpp";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-gLiITRCxX3nkzrlvU1/ZPxEo2v7q79/MwrnURUjrY28=";
=======
    hash = "sha256-Qqdw5dy+JUBSDpbWEh3Ap3+3h+CcNdfBL+rloRzWGEQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = lib.optionals finalAttrs.finalPackage.doCheck [
    "-DRAPIDFUZZ_BUILD_TESTING=ON"
  ];

  CXXFLAGS = lib.optionals stdenv.cc.isClang [
    # error: no member named 'fill' in namespace 'std'
    "-include algorithm"
  ];

  nativeCheckInputs = [
    catch2_3
  ];

  meta = {
    description = "Rapid fuzzy string matching in C++ using the Levenshtein Distance";
    homepage = "https://github.com/maxbachmann/rapidfuzz-cpp";
    changelog = "https://github.com/maxbachmann/rapidfuzz-cpp/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.unix;
  };
})
