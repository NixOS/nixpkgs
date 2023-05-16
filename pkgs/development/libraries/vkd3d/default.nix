{ lib, stdenv, fetchFromGitLab, autoreconfHook, pkg-config, wine, flex, bison
, vulkan-headers, spirv-headers, vulkan-loader }:

stdenv.mkDerivation rec {
  pname = "vkd3d";
<<<<<<< HEAD
  version = "1.8";
=======
  version = "1.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ autoreconfHook pkg-config wine flex bison ];
  buildInputs = [ vulkan-loader vulkan-headers spirv-headers ];

  src = fetchFromGitLab {
    domain = "gitlab.winehq.org";
    owner = "wine";
    repo = pname;
    rev = "${pname}-${version}";
<<<<<<< HEAD
    sha256 = "sha256-v2UhJvfB5Clupmgoykei3AoWYBOp5l9pQFkUEQVlajs=";
=======
    sha256 = "sha256-4WUD6bRG/XwrOb5tl0ZyaaR0uy85eYXcb16eDeumOAQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    homepage = "https://gitlab.winehq.org/wine/vkd3d";
    description = "A 3D graphics library with an API very similar, but not identical, to Direct3D 12";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ expipiplus1 ];
    platforms = platforms.all;
  };
}
