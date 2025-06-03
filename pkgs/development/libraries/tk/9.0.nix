{
  callPackage,
  fetchzip,
  tcl,
  ...
}@args:

callPackage ./generic.nix (
  args
  // {

    src = fetchzip {
      url = "mirror://sourceforge/tcl/tk${tcl.version}-src.tar.gz";
      hash = "sha256-eX9HSPnNHeWkCaH0TBhmxQ3keTb4he3KY5rS1w4ubTo=";
    };

    patches = [
      # https://core.tcl-lang.org/tk/tktview/765642ffffffffffffff
      ./tk-8_6_13-find-library.patch
    ];

  }
)
