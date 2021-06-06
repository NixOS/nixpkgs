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
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "NilsBrause";
    repo = pname;
    rev = version;
    sha256 = "1kxiqab48p0n97pwg8c2zx56wqq32m3rcq7qd2pjj33ipcanb3qq";
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
