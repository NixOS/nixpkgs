args: with args;

stdenv.mkDerivation {
  name = "qimageblitz-4.0.0svn";
  src = svnSrc "qimageblitz" "0rmfkl529fmlb495whlidffib1x5s03xzsyaxild3rrsf4h1npcx";
  buildInputs = [cmake qt];
}
