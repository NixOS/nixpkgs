{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "fira-mono-3.205";

  src = fetchurl {
    url = http://www.carrois.com/downloads/fira_mono_3_2/FiraMonoFonts3205.zip;
    sha256 = "0zd4wy8ksbz0qiiqgl9w7zyh34q8n983dyb44g5dfdcjakj09qlz";
  };

  buildInputs = [ unzip ];
  phases = [ "unpackPhase" "installPhase" ];
  sourceRoot = "FiraMonoFonts3205";

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
