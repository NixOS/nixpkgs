{ stdenv, fetchurl, mono, unzip, pkgconfig
 } :
stdenv.mkDerivation rec {
  pname = "fsharp";
  date = "2011-08-10";
  name = "${pname}-${date}";

  src = fetchurl {
    url = "http://download.mono-project.com/sources/fsharp/fsharp-cc126f2.zip";
    sha256 = "03j2ypnfddl2zpvg8ivhafjy8dlz49b38rdy89l8c3irxdsb7k6i";
  };

  buildInputs = [mono unzip pkgconfig];

  sourceRoot = "fsharp";

  # To fix this error when running:
  # The file "/nix/store/path/whatever.exe" is an not a valid CIL image
  dontStrip = true;

  meta = {
    description = "A functional CLI language";
    homepage = "http://tryfsharp.org/";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
