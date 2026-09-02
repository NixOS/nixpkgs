{
  lib,
  stdenv,
  callPackage,
  fetchpatch,
  fetchzip,
  ...
}@args:

callPackage ./generic.nix (
  args
  // rec {
    release = "9.0";
    version = "${release}.4";

    # Note: when updating, the hash in pkgs/development/libraries/tk/9.0.nix must also be updated!

    src = fetchzip {
      url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
      hash = "sha256-2yfj4ddGX/QT601NKG5y30LToMBu3jomFGnNUdzRaNw=";
    };

    # Gives the `win` build system the `--with-tzdata` the `unix` one always
    # had. Drop once a 9.0.x release carries it.
    #
    # `includes` leaves out `win/configure`: it is generated, and we run
    # `autoreconf` over the patched `configure.ac` ourselves.
    #
    # TODO apply unconditionally; only `win` is patched, but doing so
    # today would be a mass rebuild for a no-op elsewhere.
    patches = lib.optionals stdenv.hostPlatform.isWindows [
      (fetchpatch {
        name = "windows-disable-tzdata.patch";
        url = "https://github.com/tcltk/tcl/commit/54b509164606717adb3fbeacf71524f0a6e940f4.patch";
        includes = [
          "win/configure.ac"
          "win/Makefile.in"
        ];
        hash = "sha256-jEyT8GI8ZXNzL9OTX1z58fX8qlcixGwNlhFqxMiMga8=";
      })
    ];
  }
)
