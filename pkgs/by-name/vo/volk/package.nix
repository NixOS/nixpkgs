{ lib
, stdenv
, fetchFromGitHub
, cmake
, vulkan-headers
}:

stdenv.mkDerivation rec {
  pname = "volk";
  version = "1.3.270";

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "volk";
    rev = version;
    hash = "sha256-qf3MygaUSN31AnlR/5o0W7cqA85Fc9aT+XemaLNfWzI=";
  };

  buildInputs = [ vulkan-headers ];

  cmakeFlags = [ "-DVOLK_INSTALL=ON" ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Meta loader for Vulkan API";
    homepage = "https://github.com/zeux/volk";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "volk";
    platforms = platforms.all;
  };
}
