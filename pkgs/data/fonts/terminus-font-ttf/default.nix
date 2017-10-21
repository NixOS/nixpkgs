{ stdenv, fetchzip }:

let
  version = "4.40.1";
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

  sha256 = "0cfkpgixdz47y94s9j26pm7n4hvad23vb2q4315kgahl4294zcpg";

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
