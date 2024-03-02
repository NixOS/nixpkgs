{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "vulkan-headers";
  version = "1.3.275.0";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Headers";
    rev = "vulkan-sdk-${version}";
    hash = "sha256-kBOkj7mr4stPXUCBhNJpNL3A+9BebEwrIBEIroxdH8Y=";
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
