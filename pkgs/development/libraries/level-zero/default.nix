{ lib
, stdenv
, fetchFromGitHub
, addOpenGLRunpath
, cmake
}:

stdenv.mkDerivation rec {
  pname = "level-zero";
<<<<<<< HEAD
  version = "1.14.0";
=======
  version = "1.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "level-zero";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-7hFGY255dLgDo93+Nx2we/cfEtwaiaajdVg1VTst1/U=";
=======
    hash = "sha256-hCipWbhVsYYqfGXO6CFDPmxiFO7Dc0I/nCnj6lRS2go=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake addOpenGLRunpath ];

  postFixup = ''
    addOpenGLRunpath $out/lib/libze_loader.so
  '';

  meta = with lib; {
    description = "oneAPI Level Zero Specification Headers and Loader";
    homepage = "https://github.com/oneapi-src/level-zero";
    changelog = "https://github.com/oneapi-src/level-zero/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.ziguana ];
  };
}

