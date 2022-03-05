{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, pugixml
, wayland
, libGL
, libffi
, buildPackages
, docSupport ? true
, doxygen ? null
}:

assert docSupport -> doxygen != null;

with lib;
stdenv.mkDerivation rec {
  pname = "waylandpp";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "NilsBrause";
    repo = pname;
    rev = version;
    sha256 = "sha256-c7sayJjQaqJWso2enESBx6OUW9vxxsfuHFolYDIYlXw=";
  };

  cmakeFlags = [
    "-DCMAKE_INSTALL_DATADIR=${placeholder "dev"}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DWAYLAND_SCANNERPP=${buildPackages.waylandpp}/bin/wayland-scanner++"
  ];

  nativeBuildInputs = [ cmake pkg-config ] ++ optional docSupport doxygen;
  buildInputs = [ pugixml wayland libGL libffi ];

  outputs = [ "bin" "dev" "lib" "out" ] ++ optionals docSupport [ "doc" "devman" ];

  meta = with lib; {
    description = "Wayland C++ binding";
    homepage = "https://github.com/NilsBrause/waylandpp/";
    license = with licenses; [ bsd2 hpnd ];
    maintainers = with maintainers; [ minijackson ];
  };
}
