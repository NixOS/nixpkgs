{ stdenv, fetchurl }:
{ version, baseName, package, sha512, type ? "jar" }:

let
  name = "${baseName}-${version}";
  m2Path = "${package}/${baseName}/${version}";
  m2File = "${name}.${type}";
  src = fetchurl rec {
      inherit sha512;
      url = "mirror://maven/${m2Path}/${m2File}";
  };
in stdenv.mkDerivation rec {
  inherit name m2Path m2File src;

  installPhase = ''
    mkdir -p $out/m2/$m2Path
    cp $src $out/m2/$m2Path/$m2File
  '';

  phases = "installPhase";
}
