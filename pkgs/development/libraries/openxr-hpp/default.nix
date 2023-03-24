{ lib
, fetchFromGitHub
, cmake
, stdenv
, python3
, python3Packages
, vulkan-loader
, vulkan-headers
, openxr-loader
, gtest
}:
stdenv.mkDerivation rec {
  pname = "openxr-hpp";
  version = "1.0.26";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenXR-HPP";
    rev = "release-${version}";
    hash = "sha256-JEqE5QLpgec+/RMWrmGCi6w7/n53t9ThjxwbgqT4lNk=";
  };

  nativeBuildInputs = [ cmake python3 python3Packages.jinja2 vulkan-loader vulkan-headers openxr-loader ];

  cmakeFlags = [
    "-DBUILD_TESTS=${if doCheck then "ON" else "OFF"}"
    "-DSKIP_EZVCPKG=ON"
    "-DOPENXR_SDK_SRC_DIR=${openxr-loader.src}"
  ];

  buildPhase = ''
    make generate_headers
  '';

  doCheck = true;
  checkInputs = [ gtest ];

  meta = with lib; {
    description = "Open-Source OpenXR C++ language projection";
    homepage = "https://github.com/KhronosGroup/OpenXR-Hpp";
    license = licenses.asl20;
    maintainers = with maintainers; [ kyaru ];
  };
}
