{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "fira-mono-3.203";

  src = fetchurl {
    url = http://www.carrois.com/downloads/fira_mono_3_2/FiraMonoFonts3203.zip;
    sha256 = "0qaplpmsqys42a49x8d15ca2gqw1v6a6k2d56ja1j38dmr2qmpv4";
  };

  buildInputs = [ unzip ];
  phases = [ "unpackPhase" "installPhase" ];
  sourceRoot = "FiraMonoFonts3203";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    find . -name "*.otf" -exec cp -v {} $out/share/fonts/opentype \;
  '';

  meta = with stdenv.lib; {
    homepage = http://www.carrois.com/fira-4-1/;
    description = "Monospace font for Firefox OS";
    longDescription = ''
      Fira Mono is a monospace font designed by Erik Spiekermann,
      Ralph du Carrois, Anja Meiners and Botio Nikoltchev of Carrois
      Type Design for Mozilla Firefox OS. Available in Regular,
      Medium, and Bold.
    '';
    license = licenses.ofl;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
