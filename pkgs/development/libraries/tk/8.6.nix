{
  callPackage,
  fetchurl,
  tcl,
  ...
}@args:

callPackage ./generic.nix (
  args
  // {

    src = fetchurl {
      url = "mirror://sourceforge/tcl/tk${tcl.version}-src.tar.gz";
      hash = "sha256-vp+U01ddSzCZ2EvDwQ3omU3y16pAUggXPHCcxASn5f4=";
    };

    patches = [
      ./tk-8_6_13-find-library.patch
    ];

  }
)
