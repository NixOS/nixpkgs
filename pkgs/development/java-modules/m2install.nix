{ stdenv, fetchurl }:
{ version, artifactId, groupId, sha512, type ? "jar", suffix ? "" }:

let
  name = "${artifactId}-${version}";
  m2Path = "${builtins.replaceStrings ["."] ["/"] groupId}/${artifactId}/${version}";
  m2File = "${name}${suffix}.${type}";
  src = fetchurl {
      inherit sha512;
      url = "mirror://maven/${m2Path}/${m2File}";
  };
in stdenv.mkDerivation {
  inherit name m2Path m2File src;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/m2/$m2Path
    cp $src $out/m2/$m2Path/$m2File
  '';
}
