{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, faad2, fftwFloat, zlib
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "dab_lib";
  version = "unstable-2023-03-02";

  src = fetchFromGitHub {
    owner = "JvanKatwijk";
    repo = "dab-cmdline";
    rev = "d615e2ba085f91dc7764cc28dfc4c9df49ee1a93";
    hash = "sha256-KSkOg0a5iq+13kClQqj+TaEP/PsLUrm8bMmiJEAZ+C4=";
  };

<<<<<<< HEAD
  sourceRoot = "${finalAttrs.src.name}/library";
=======
  sourceRoot = "source/library/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ faad2 fftwFloat zlib ];

  meta = with lib; {
    description = "DAB/DAB+ decoding library";
    homepage = "https://github.com/JvanKatwijk/dab-cmdline";
    license = licenses.gpl2;
    maintainers = with maintainers; [ alexwinter ];
    platforms = platforms.unix;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
