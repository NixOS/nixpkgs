{ kdeFramework, lib, copyPathsToStore, cmake, pkgconfig, qttools }:

kdeFramework {
  name = "extra-cmake-modules";

  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);

  outputs = [ "out" ];  # this package has no runtime components
  setupHook = ./setup-hook.sh;

  # It is OK to propagate these inputs as long as
  # extra-cmake-modules is never a propagated input
  # of some other derivation.
  propagatedNativeBuildInputs = [ cmake pkgconfig qttools ];

  meta = with lib; {
    license = licenses.bsd2;
    maintainers = [ maintainers.ttuegel ];
  };
}
