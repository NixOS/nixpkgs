{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, pugixml
, wayland
, libGL
, libffi
, buildPackages
, docSupport ? true
, doxygen ? null
}:

assert docSupport -> doxygen != null;

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "waylandpp";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "NilsBrause";
    repo = pname;
    rev = version;
    sha256 = "1r4m0xhvwpcqxrqvp3hz1bzlkxqj2jiymd5r6hj8xjzz536hyprz";
  };

  cmakeFlags = [ 
    "-DCMAKE_INSTALL_DATADIR=${placeholder "dev"}" 
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DWAYLAND_SCANNERPP=${buildPackages.waylandpp}/bin/wayland-scanner++"
  ];

  nativeBuildInputs = [ cmake pkgconfig ] ++ optional docSupport doxygen;
  buildInputs = [ pugixml wayland libGL libffi ];

  outputs = [ "bin" "dev" "lib" "out" ] ++ optionals docSupport [ "doc" "devman" ];

  meta = with stdenv.lib; {
    description = "Wayland C++ binding";
    homepage = "https://github.com/NilsBrause/waylandpp/";
    license = with licenses; [ bsd2 hpnd ];
    maintainers = with maintainers; [ minijackson ];
  };
}
