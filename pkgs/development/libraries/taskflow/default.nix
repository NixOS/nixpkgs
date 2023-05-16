{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, doctest
, cmake
}:

stdenv.mkDerivation rec {
  pname = "taskflow";
<<<<<<< HEAD
  version = "3.6.0";
=======
  version = "3.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "taskflow";
    repo = "taskflow";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Iy9BhkyJa2nFxwVXb4LAlgVAHnu+58Ago2eEgAIlZ7M=";
=======
    hash = "sha256-UUWJENGn60YQdUSQ55uL+/3xt/JUsVuKnqm/ef7wPVM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    (substituteAll {
      src = ./unvendor-doctest.patch;
      inherit doctest;
    })
  ];

  postPatch = ''
    rm -r 3rd-party

    # tries to use x86 intrinsics on aarch64-darwin
    sed -i '/^#if __has_include (<immintrin\.h>)/,/^#endif/d' taskflow/utility/os.hpp
  '';

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = {
    description = "General-purpose Parallel and Heterogeneous Task Programming System";
    homepage = "https://taskflow.github.io/";
    changelog = let
      release = lib.replaceStrings ["."] ["-"] version;
    in "https://taskflow.github.io/taskflow/release-${release}.html";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
