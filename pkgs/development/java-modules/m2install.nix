{ stdenv, fetchurl }:
{ version, artifactId, groupId, sha512, type ? "jar", suffix ? "" }:

let
  m2Path = "${builtins.replaceStrings ["."] ["/"] groupId}/${artifactId}/${version}";
  m2File = "${artifactId}-${version}${suffix}.${type}";
  src = fetchurl {
      inherit sha512;
      url = "mirror://maven/${m2Path}/${m2File}";
  };
in stdenv.mkDerivation {
  inherit version m2Path m2File src;
  pname = artifactId;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/m2/$m2Path
    cp $src $out/m2/$m2Path/$m2File
  '';
}
