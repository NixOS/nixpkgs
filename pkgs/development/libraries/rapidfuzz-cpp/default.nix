{ lib
, stdenv
, fetchFromGitHub
, cmake
, catch2_3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapidfuzz-cpp";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "rapidfuzz-cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yEDihPvTGGL5gsd4QMYNRyfLucKLItIQM4pm6W0i2W8=";
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
