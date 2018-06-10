{ stdenv, fetchzip }:

fetchzip {
  name = "fira-mono-3.206";

  url = http://www.carrois.com/downloads/fira_mono_3_2/FiraMonoFonts3206.zip;

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "0m4kdjh4xjyznybpgh21a0gibv4wsxq0rqyl3wv942zk6mclmgdf";

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
