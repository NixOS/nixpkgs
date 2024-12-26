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
      sha256 = "sha256-jQ9kZuFx6ikQ+SpY7kSbvXJ5hjw4WB9VgRaNlQLtG0s=";
    };

    patches = [
      # https://core.tcl-lang.org/tk/tktview/765642ffffffffffffff
      ./tk-8_6_13-find-library.patch
    ];

  }
)
