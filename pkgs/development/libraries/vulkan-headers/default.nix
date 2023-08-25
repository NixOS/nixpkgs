{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "vulkan-headers";
  version = "1.3.254";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Headers";
    rev = "v${version}";
    hash = "sha256-4erHZKx4jksAtyG8ZHtlVoEY3EqE4p2pEtcGHqv7G7A=";
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
