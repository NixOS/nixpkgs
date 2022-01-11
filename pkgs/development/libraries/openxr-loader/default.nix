{ lib, stdenv, fetchFromGitHub, cmake, python3, libX11, libXxf86vm, libXrandr, vulkan-headers, libGL }:

stdenv.mkDerivation rec {
  pname = "openxr-loader";
  version = "1.0.20";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenXR-SDK-Source";
    rev = "release-${version}";
    sha256 = "sha256-afyAHTyW9x2KxR1q/K3t5Dpv9OzATcYiSgiDn2S924E=";
  };

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ libX11 libXxf86vm libXrandr vulkan-headers libGL ];

  cmakeFlags = [ "-DBUILD_TESTS=OFF" ];

  outputs = [ "out" "dev" "layers" ];

  postInstall = ''
    mkdir -p "$layers/share"
    mv "$out/share/openxr" "$layers/share"
    # Use absolute paths in manifests so no LD_LIBRARY_PATH shenanigans are necessary
    for file in "$layers/share/openxr/1/api_layers/explicit.d/"*; do
        substituteInPlace "$file" --replace '"library_path": "lib' "\"library_path\": \"$layers/lib/lib"
    done
    mkdir -p "$layers/lib"
    mv "$out/lib/libXrApiLayer"* "$layers/lib"
  '';

  meta = with lib; {
    description = "Khronos OpenXR loader";
    homepage    = "https://www.khronos.org/openxr";
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
