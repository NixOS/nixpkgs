{ stdenv, fetchzip }:

fetchzip rec {
  name = "profont";

  url = "http://tobiasjung.name/downloadfile.php?file=profont-x11.zip";

  postFetch = ''
    unzip -j $downloadedFile

    mkdir -p $out/share/doc/$name $out/share/fonts/misc

    cp LICENSE $out/share/doc/$name/LICENSE

    for f in *.pcf; do
      gzip -c "$f" > $out/share/fonts/misc/"$f".gz
    done
  '';

  sha256 = "1calqmvrfv068w61f614la8mg8szas6m5i9s0lsmwjhb4qwjyxbw";

  meta = with stdenv.lib; {
    homepage = http://tobiasjung.name;
    description = "A monospaced font created to be a most readable font for programming";
    maintainers = with stdenv.lib.maintainers; [ myrl ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
