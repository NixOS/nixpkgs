{ lib, runCommand, fetchurl }:

runCommand "sampradaya-2015-05-26" {
  src = fetchurl {
    url = "https://bitbucket.org/OorNaattaan/sampradaya/raw/afa9f7c6ab17e14bd7dd74d0acaec2f75454dfda/Sampradaya.ttf";
    sha256 = "0110k1yh5kz3f04wp72bfz59pxjc7p6jv7m5p0rqn1kqbf7g3pck";
  };

  meta = with lib; {
    homepage = https://bitbucket.org/OorNaattaan/sampradaya/;
    description = "Unicode-compliant Grantha font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.ofl; # See font metadata
    platforms = platforms.all;
  };
}
''
  mkdir -p $out/share/fonts/truetype
  cp $src $out/share/fonts/truetype/Sampradaya.ttf
''
