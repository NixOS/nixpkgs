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
      sha256 = "sha256-VQlp81N5+VKzAg86t7ndW/0Rwe98m3xqdfXEmsp5P+w=";
    };

    patches = [
      ./tk-8_6_13-find-library.patch
    ];

  }
)
