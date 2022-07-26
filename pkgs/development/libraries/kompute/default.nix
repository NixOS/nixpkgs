{ lib
, stdenv
, fetchFromGitHub
, cmake
, vulkan-headers
, vulkan-loader
, fmt
, glslang
, ninja
}:

stdenv.mkDerivation rec {
  pname = "kompute";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "KomputeProject";
    repo = "kompute";
    rev = "v${version}";
    sha256 = "sha256-OkVGYh8QrD7JNqWFBLrDTYlk6IYHdvt4i7UtC4sQTzo=";
  };

  cmakeFlags = [
    "-DKOMPUTE_OPT_INSTALL=1"
    "-DRELEASE=1"
    "-DKOMPUTE_ENABLE_SPDLOG=1"
  ];

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ fmt ];
  propagatedBuildInputs = [ glslang vulkan-headers vulkan-loader ];

  meta = with lib; {
    description = "General purpose GPU compute framework built on Vulkan";
    longDescription = ''
      General purpose GPU compute framework built on Vulkan to
      support 1000s of cross vendor graphics cards (AMD,
      Qualcomm, NVIDIA & friends). Blazing fast, mobile-enabled,
      asynchronous and optimized for advanced GPU data
      processing usecases. Backed by the Linux Foundation"
    '';
    homepage = "https://kompute.cc/";
    license = licenses.asl20;
    maintainers = with maintainers; [ atila ];
    platforms = platforms.linux;
  };
}
