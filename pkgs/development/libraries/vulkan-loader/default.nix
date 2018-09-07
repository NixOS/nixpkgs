{ stdenv, fetchFromGitHub, cmake, python3, vulkan-headers, pkgconfig,
  xlibsWrapper, libxcb, libXrandr, libXext, wayland, libGL_driver }:
let version = "1.1.82.0"; in
assert version == vulkan-headers.version;
stdenv.mkDerivation rec {
  name = "vulkan-loader-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Loader";
    rev = "sdk-${version}";
    sha256 = "16i4s1adfh822ahj3ywp279lv6szwd2sn2q5pmvpg2kk6mbh410d";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake python3 xlibsWrapper libxcb libXrandr libXext wayland ];
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DFALLBACK_DATA_DIRS=${libGL_driver.driverLink}/share:/usr/local/share:/usr/share"
    "-DVULKAN_HEADERS_INSTALL_DIR=${vulkan-headers}"
  ];

  outputs = [ "out" "dev" ];

  postInstall = ''
    cp -r "${vulkan-headers}/include" "$dev"
  '';

  meta = with stdenv.lib; {
    description = "LunarG Vulkan loader";
    homepage    = https://www.lunarg.com;
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
