{
  callPackage,
  fetchpatch2,
}:
let
  mkVtk = initArgs: callPackage (import ./generic.nix initArgs) { };
in
{
  vtk_9_5 = mkVtk {
    version = "9.5.2";
    sourceSha256 = "sha256-zuZLmNJw/3MC2vHvE0WN/11awey0XUdyODX399ViyYk=";
    patches = [
      # Finding `Boost::system` fails because the stub compiled library of
      # Boost.System, which has been a header-only library since 1.69, was
      # removed in 1.89.
      # See https://www.boost.org/releases/1.89.0/ for details.
      #
      # Also, the link interface of libLAS contains `Boost::serialization`
      # as a dependency, so we need to add that to `boost_components`.
      ./boost-1.89.patch
    ];
  };
}
