{ lib, fetchzip }:

let
  version = "4.47.0";
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

  sha256 = "1mnx3vlnl0r15yzsa4zb9qqab4hpi603gdwhlbw960wg03i3xn8z";

  meta = with lib; {
    description = "A clean fixed width TTF font";
    longDescription = ''
      Monospaced bitmap font designed for long work with computers
      (TTF version, mainly for Java applications)
    '';
    homepage = http://files.ax86.net/terminus-ttf;
    license = licenses.ofl;
    maintainers = with maintainers; [ okasu ];
  };
}
