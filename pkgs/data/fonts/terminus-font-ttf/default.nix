{ stdenv, fetchzip }:

let
  version = "4.46.0";
in fetchzip rec {
  name = "terminus-font-ttf-${version}";

  url = "http://files.ax86.net/terminus-ttf/files/${version}/terminus-ttf-${version}.zip";

  postFetch = ''
    unzip -j $downloadedFile

    for i in *.ttf; do
      local destname="$(echo "$i" | sed -E 's|-[[:digit:].]+\.ttf$|.ttf|')"
      install -Dm 644 "$i" "$out/share/fonts/truetype/$destname"
    done

    install -Dm 644 COPYING "$out/share/doc/terminus-font-ttf/COPYING"
  '';

  sha256 = "129rfmwnm2bhp99w4zl262l6sdx8pddc0gf1ispjqs6dz3m3mdkp";

  meta = with stdenv.lib; {
    description = "A clean fixed width TTF font";
    longDescription = ''
      Monospaced bitmap font designed for long work with computers
      (TTF version, mainly for Java applications)
    '';
    homepage = http://files.ax86.net/terminus-ttf;
    license = licenses.ofl;
    maintainers = with maintainers; [ okasu ];
    platforms = platforms.unix;
  };
}
