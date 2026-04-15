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
      hash = "sha256-ssgvJdgXCtBPfnPvX9AR9uo4zGbzRGsCjOowxe5cfjM=";
    };

    patches = [
      # https://core.tcl-lang.org/tk/tktview/765642ffffffffffffff
      ./tk-8_6_13-find-library.patch
    ];

  }
)
