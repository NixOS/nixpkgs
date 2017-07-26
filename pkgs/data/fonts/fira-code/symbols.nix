{ stdenv, runCommand, fetchurl, unzip }:

runCommand "fira-code-symbols-20160811" {
  src = fetchurl {
    url = "https://github.com/tonsky/FiraCode/files/412440/FiraCode-Regular-Symbol.zip";
    sha256 = "01sk8cmm50xg2vwf0ff212yi5gd2sxcb5l4i9g004alfrp7qaqxg";
  };
  buildInputs = [ unzip ];

  meta = with stdenv.lib; {
    description = "FiraCode unicode ligature glyphs in private use area";
    longDescription = ''
      FiraCode uses ligatures, which some editors don’t support.
      This addition adds them as glyphs to the private unicode use area.
      See https://github.com/tonsky/FiraCode/issues/211.
    '';
    license = licenses.ofl;
    maintainers = [ maintainers.profpatsch ];
    homepage = "https://github.com/tonsky/FiraCode/issues/211#issuecomment-239058632";
  };
} ''
  mkdir -p $out/share/fonts/opentype
  unzip "$src" -d $out/share/fonts/opentype
''
