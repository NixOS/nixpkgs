args: with args;

stdenv.mkDerivation {
  name = "qimageblitz-4.0.0svn";
  src = svnSrc "qimageblitz" "0vsan536qv8hj8l8ghmji62xzc75xm896h7fpwk48vq9f8w9fn4q";
  buildInputs = [cmake qt];
}
