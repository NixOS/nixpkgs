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
      hash = "sha256-GhCJF3hF3izK6oYEJIaxoGRn3PHPigJv2ThWBTS6bTE=";
    };

    patches = [
      # https://core.tcl-lang.org/tk/tktview/765642ffffffffffffff
      ./tk-8_6_13-find-library.patch
    ];

  }
)
