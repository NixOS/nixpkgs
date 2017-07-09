{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "terminus-font-ttf-${version}";
  version = "4.40.1";

  src = fetchurl {
    url = "http://files.ax86.net/terminus-ttf/files/${version}/terminus-ttf-${version}.zip";
    sha256 = "c3cb690c2935123035a0b1f3bfdd9511c282dab489cd423e161a47c592edf188";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    for i in *.ttf; do
      local destname="$(echo "$i" | sed -E 's|-[[:digit:].]+\.ttf$|.ttf|')"
      install -Dm 644 "$i" "$out/share/fonts/truetype/$destname"
    done

    install -Dm 644 COPYING "$out/share/doc/terminus-font-ttf/COPYING"
  '';

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
