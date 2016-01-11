{ stdenv, fetchurl }:
{ version, name, src, m2Path, m2File }: 


stdenv.mkDerivation rec {
  inherit name src m2Path m2File;

  installPhase = ''
    echo $out
    mkdir -p $out/m2/$m2Path
    cp $src $out/m2/$m2Path/$m2File
  '';

  phases = "installPhase";
}
