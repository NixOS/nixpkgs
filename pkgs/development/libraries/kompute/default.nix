{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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

  patches = [
    (fetchpatch {
      url = "https://github.com/KomputeProject/kompute/commit/9a791b161dd58ca927fe090f65fa2b0e5e85e7ca.diff";
      sha256 = "OtFTN8sgPlyiMmVzUnqzCkVMKj6DWxbCXtYwkRdEprY=";
    })
    (fetchpatch {
      name = "enum-class-fix-for-fmt-8-x.patch";
      url = "https://github.com/KomputeProject/kompute/commit/f731f2e55c7aaaa804111106c3e469f9a642d4eb.patch";
      sha256 = "sha256-scTCYqkgKQnH27xzuY4FVbiwRuwBvChmLPPU7ZUrrL0=";
    })
  ];

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
