{ lib
, stdenv
, fetchFromGitHub
, cmake
, catch2
}:

stdenv.mkDerivation rec {
  pname = "jarowinkler-cpp";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "jarowinkler-cpp";
    rev = "v${version}";
    hash = "sha256-6dIyCyoPs/2wHyGqlE+NC0pwz5ggS5edhN4Jbltx0jg=";
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
    description = "Fast Jaro and Jaro-Winkler distance";
    homepage = "https://github.com/maxbachmann/jarowinkler-cpp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.unix;
  };
}
