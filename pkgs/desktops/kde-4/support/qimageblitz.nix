args: with args;

stdenv.mkDerivation {
  name = "qimageblitz-4.0.0svn";
  src = svnSrc "qimageblitz" "530ff28d52fef632642be1879c5b190ac9183013a08969b135b4823bab48e8bc";
  buildInputs = [cmake qt];
}
