{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "vulkan-headers";
  version = "1.3.211.0";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Headers";
    rev = "sdk-${version}";
    sha256 = "sha256-FqrcFHsUS8e4ZgZpxVc8nNZWdNltniFmMjyyWVoNc7w=";
  };

  meta = with lib; {
    description = "Vulkan Header files and API registry";
    homepage    = "https://www.lunarg.com";
    platforms   = platforms.unix;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
