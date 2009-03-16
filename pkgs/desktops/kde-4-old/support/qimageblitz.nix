args: with args;

stdenv.mkDerivation {
  name = "qimageblitz-4.0.0svn";
  src = svnSrc "qimageblitz" "0gi78bald70bc540jqcpa70x23hycywibn4raf5602hv4d5n8mnx";
  buildInputs = [cmake qt];
}
