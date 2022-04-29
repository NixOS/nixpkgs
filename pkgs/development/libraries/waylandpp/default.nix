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
, graphviz ? null
}:

assert docSupport -> doxygen != null;

with lib;
stdenv.mkDerivation rec {
  pname = "waylandpp";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "NilsBrause";
    repo = pname;
    rev = version;
    sha256 = "sha256-5/u6tp7/E4tjSfX+QJFmcUYdnyOgl9rB79PDE/SJH1o=";
  };

  cmakeFlags = [
    "-DCMAKE_INSTALL_DATADIR=${placeholder "dev"}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DWAYLAND_SCANNERPP=${buildPackages.waylandpp}/bin/wayland-scanner++"
  ];

  nativeBuildInputs = [ cmake pkg-config ] ++ optionals docSupport [ doxygen graphviz ];
  buildInputs = [ pugixml wayland libGL libffi ];

  outputs = [ "bin" "dev" "lib" "out" ] ++ optionals docSupport [ "doc" "devman" ];

  meta = with lib; {
    description = "Wayland C++ binding";
    homepage = "https://github.com/NilsBrause/waylandpp/";
    license = with licenses; [ bsd2 hpnd ];
    maintainers = with maintainers; [ minijackson ];
  };
}
