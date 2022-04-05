{ mkDerivation, lib, cmake, pkg-config }:

mkDerivation {
  pname = "extra-cmake-modules";

  patches = [
    ./nix-lib-path.patch
  ];

  outputs = [ "out" ];  # this package has no runtime components

  propagatedBuildInputs = [ cmake pkg-config ];

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    platforms = platforms.linux ++ platforms.darwin;
    homepage = "http://www.kde.org";
    license = licenses.bsd2;
  };
}
