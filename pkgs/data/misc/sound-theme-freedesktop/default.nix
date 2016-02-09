{ stdenv, fetchurl, intltool }:

stdenv.mkDerivation rec {
  name = "sound-theme-freedesktop-${version}";
  version = "0.8";

  src = fetchurl {
    sha256 = "054abv4gmfk9maw93fis0bf605rc56dah7ys5plc4pphxqh8nlfb";
    url = "https://people.freedesktop.org/~mccann/dist/${name}.tar.bz2";
  };

  nativeBuildInputs = [ intltool ];

  meta = with stdenv.lib; {
    description = "Freedesktop reference sound theme";
    homepage = http://freedesktop.org/wiki/Specifications/sound-theme-spec;
    # See http://cgit.freedesktop.org/sound-theme-freedesktop/tree/CREDITS:
    license = with licenses; [ cc-by-30 cc-by-sa-25 gpl2 gpl2Plus ];
    maintainers = with maintainers; [ nckx ];
  };
}
