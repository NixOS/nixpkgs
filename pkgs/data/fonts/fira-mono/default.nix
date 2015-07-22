{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "fira-mono-3.204";

  src = fetchurl {
    url = http://www.carrois.com/downloads/fira_mono_3_2/FiraMonoFonts3204.zip;
    sha256 = "0pnsw7b1i5vkwq0kny4lxzly4h8rlwkj610rykhax6zayfbnz62a";
  };

  buildInputs = [ unzip ];
  phases = [ "unpackPhase" "installPhase" ];
  sourceRoot = "FiraMonoFonts3204";

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
