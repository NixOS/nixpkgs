# The _cuda attribute set is a fixed-point which contains the static functionality required to construct CUDA package
# sets. For example, `_cuda.bootstrapData` includes information about NVIDIA's redistributables (such as the names
# NVIDIA uses for different systems), `_cuda.lib` contains utility functions like `formatCapabilities` (which generate
# common arguments passed to NVCC and `cmakeFlags`), and `_cuda.fixups` contains `callPackage`-able functions which
# are provided to the corresponding package's `overrideAttrs` attribute to provide package-specific fixups
# out of scope of the generic redistributable builder.
#
# Since this attribute set is used to construct the CUDA package sets, it must exist outside the fixed point of the
# package sets. Make these attributes available directly in the package set construction could cause confusion if
# users override the attribute set with the expection that changes will be reflected in the enclosing CUDA package
# set. To avoid this, we declare `_cuda` and inherit its members here, at top-level. (This also allows us to benefit
# from import caching, as it should be evaluated once per system, rather than per-system and CUDA package set.)

let
  lib = import ../../../../lib;
in
lib.fixedPoints.makeExtensible (final: {
  bootstrapData = import ./db/bootstrap {
    inherit lib;
  };
  db = import ./db {
    inherit (final) bootstrapData db;
    inherit lib;
  };
  extensions = [ ]; # Extensions applied to every CUDA package set.
  fixups = import ./fixups { inherit lib; };
  lib = import ./lib {
    _cuda = final;
    inherit lib;
  };
})
