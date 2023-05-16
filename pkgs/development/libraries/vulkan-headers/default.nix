{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "vulkan-headers";
<<<<<<< HEAD
  version = "1.3.261";
=======
  version = "1.3.249";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Headers";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-zKHew7SGUq1C3XGp/HrCle6KyqB4cziPcTYVqAr814s=";
=======
    hash = "sha256-PLqF9lO7vWvgRZvXLmOcNhTgkB+3TXUa0eoALwDc5Ws=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Vulkan Header files and API registry";
    homepage    = "https://www.lunarg.com";
    platforms   = platforms.unix ++ platforms.windows;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
