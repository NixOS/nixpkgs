{
  lib,
  buildDunePackage,
  fetchurl,
}:
buildDunePackage rec {
  pname = "ancient";
  version = "0.10.0";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/OCamlPro/ocaml-ancient/releases/download/${version}/ancient-${version}.tbz";
    hash = "sha256-XeVUPrdg7QSV7V0Tz8Mkj5jvzKtYD9DON+tt9kkuCHM=";
  };

  doCheck = true;

  meta = {
    description = "Use data structures larger than available memory";
    longDescription = ''
      This module allows you to use in-memory data structures which are
      larger than available memory and so are kept in swap.  If you try this
      in normal OCaml code, you'll find that the machine quickly descends
      into thrashing as the garbage collector repeatedly iterates over
      swapped memory structures.  This module lets you break that
      limitation.  Of course the module doesn't work by magic :-) If your
      program tries to access these large structures, they still need to be
      swapped back in, but it is suitable for large, sparsely accessed
      structures.

      Secondly, this module allows you to share those structures between
      processes.  In this mode, the structures are backed by a disk file,
      and any process that has read/write access that disk file can map that
      file in and see the structures.
    '';
    homepage = "https://github.com/OCamlPro/ocaml-ancient";
    changelog = "https://raw.githubusercontent.com/OCamlPro/ocaml-ancient/refs/tags/${version}/CHANGES.md";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
