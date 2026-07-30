lib: version:

let
  fragments = lib.splitVersion version;
  major = lib.head fragments;
  minor = lib.concatMapStrings (lib.fixedWidthNumber 2) (lib.tail fragments);
in

major + minor + "00"
