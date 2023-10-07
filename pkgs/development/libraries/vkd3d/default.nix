{ lib, stdenv, fetchFromGitLab, autoreconfHook, pkg-config, wine, flex, bison
, vulkan-headers, spirv-headers, vulkan-loader }:

stdenv.mkDerivation rec {
  pname = "vkd3d";
  version = "1.9";

  nativeBuildInputs = [ autoreconfHook pkg-config wine flex bison ];
  buildInputs = [ vulkan-loader vulkan-headers spirv-headers ];

  src = fetchFromGitLab {
    domain = "gitlab.winehq.org";
    owner = "wine";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-IF7TOKxNEWr1p4DpIqoRCeVzi9b3yN8XrmWTMvfoOqw=";
  };

  meta = with lib; {
    homepage = "https://gitlab.winehq.org/wine/vkd3d";
    description = "A 3D graphics library with an API very similar, but not identical, to Direct3D 12";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ expipiplus1 ];
    platforms = platforms.all;
  };
}
