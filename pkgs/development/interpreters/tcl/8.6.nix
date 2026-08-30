{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  fetchpatch,
  ...
}@args:

callPackage ./generic.nix (
  args
  // rec {
    release = "8.6";
    version = "${release}.16";

    # Note: when updating, the hash in pkgs/development/libraries/tk/8.6.nix must also be updated!

    src = fetchurl {
      url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
      hash = "sha256-kcuPphdxxjwmLvtVMFm3x61nV6+lhXr2Jl5LC9wqFKU=";
    };

    patches =
      # Cygwin wants the DLL in `bin` and an import library,
      # `libtcl8.6.dll.a`, in `lib`; that is what `tclConfig.sh` describes
      # when it says `-L${libdir} -ltcl8.6`. This branch's `unix` build
      # system builds no import library at all, so nothing can link against
      # Tcl. Upstream fixed that on 9.0 and never backported it.
      #
      # https://core.tcl-lang.org/tcl/tktview/17960b80db
      #
      # `decode` renames the path: 9.0 has `unix/configure.ac` where this
      # branch still has `unix/configure.in`. The hunks themselves apply as
      # they are. `includes` drops the rest of the check-in: the generated
      # `unix/configure`, which `autoreconfHook` rebuilds anyway, and a
      # `changes.md` entry that has no counterpart here.
      lib.optionals stdenv.hostPlatform.isCygwin [
        (fetchpatch {
          url = "https://github.com/tcltk/tcl/commit/1685fee268dcf1334b015840d873366a3cd8d237.patch";
          decode = "sed -e 's|configure[.]ac|configure.in|g'";
          includes = [
            "unix/tcl.m4"
            "unix/configure.in"
          ];
          hash = "sha256-SWZuY4NvN9z9ka+TTICbCxPZHzhV/8JYDRPI/Vhc/8o=";
        })
      ]
      # Backport of upstream check-in `fd06472ef41e1d73`; see the patch.
      # TODO apply unconditionally; only `win` is patched, but doing so
      # today would be a mass rebuild for a no-op elsewhere.
      ++ lib.optionals stdenv.hostPlatform.isWindows [
        ./8.6-windows-disable-tzdata.patch
      ];
  }
)
