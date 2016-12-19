{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "profont";

  src = fetchurl {
    url = "http://tobiasjung.name/downloadfile.php?file=profont-x11.zip";
    sha256 = "19ww5iayxzxxgixa9hgb842xd970mwghxfz2vsicp8wfwjh6pawr";
  };

  buildInputs = [ unzip ];

  phases = [ "unpackPhase" "installPhase" ];
  installPhase =
    ''
      mkdir -p $out/share/doc/$name $out/share/fonts/misc

      cp LICENSE $out/share/doc/$name/LICENSE

      for f in *.pcf; do
        gzip -c "$f" > $out/share/fonts/misc/"$f".gz
      done
    '';

  meta = with stdenv.lib; {
    homepage = http://tobiasjung.name;
    description = "A monospaced font created to be a most readable font for programming";
    maintainers = with stdenv.lib.maintainers; [ myrl ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
