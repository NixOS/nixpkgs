{ kdeFramework, lib, stdenv, cmake, pkgconfig, qttools }:

kdeFramework {
  name = "extra-cmake-modules";
  patches = [ ./0001-extra-cmake-modules-paths.patch ];

  setupHook = ./setup-hook.sh;

  # It is OK to propagate these inputs as long as
  # extra-cmake-modules is never a propagated input
  # of some other derivation.
  propagatedNativeBuildInputs = [ cmake pkgconfig qttools ];

  meta = {
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
