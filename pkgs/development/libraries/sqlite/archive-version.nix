lib: version:

with lib;
  
let
  fragments = splitString "." version;
  major = head fragments;
  minor = concatMapStrings (fixedWidthNumber 2) (tail fragments);
in

major + minor + "00"
