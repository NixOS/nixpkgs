{ mkDerivation }:

mkDerivation rec {
  version = "21.1";
  sha256 = "0a31kn6h2qgdzdy3247f7x6j0cywzzf1938h82jc3sq571h5i9wf";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
