{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "cjson";
<<<<<<< HEAD
  version = "1.7.16";
=======
  version = "1.7.15";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "DaveGamble";
    repo = "cJSON";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-sdhnDpaAO9Fau4uMzNXrbOJ2k0b8+MdhKh6rpFMUwaQ=";
=======
    sha256 = "sha256-PpUVsLklcs5hCCsQcsXw0oEVIWecKnQO16Hy0Ba8ov8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  # cJSON actually uses C99 standard, not C89
  # https://github.com/DaveGamble/cJSON/issues/275
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace -std=c89 -std=c99
  '';

  meta = with lib; {
    homepage = "https://github.com/DaveGamble/cJSON";
    description = "Ultralightweight JSON parser in ANSI C";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
  };
}
