{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "vulkan-headers";
  version = "1.3.239.0";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Headers";
    rev = "sdk-${version}";
    hash = "sha256-mzxT6s4ZHShB9tGyyf8jDtVWVEclHPYW+9oKy7v0bC4=";
  };

  meta = with lib; {
    description = "Vulkan Header files and API registry";
    homepage    = "https://www.lunarg.com";
    platforms   = platforms.unix ++ platforms.windows;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
