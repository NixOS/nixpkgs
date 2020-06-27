{ stdenv, mkFont, fetchzip }:

mkFont rec {
  pname = "fira-code-symbols";
  version = "20160811";

  src = fetchzip {
    url = "https://github.com/tonsky/FiraCode/files/412440/FiraCode-Regular-Symbol.zip";
    sha256 = "1bi118v4ga13ja88a27zamyjv66c7jnv9wmcy4gypl17a5p7abpg";
  };

  meta = with stdenv.lib; {
    description = "FiraCode unicode ligature glyphs in private use area";
    longDescription = ''
      FiraCode uses ligatures, which some editors don’t support.
      This addition adds them as glyphs to the private unicode use area.
      See https://github.com/tonsky/FiraCode/issues/211.
    '';
    license = licenses.ofl;
    maintainers = [ maintainers.Profpatsch ];
    homepage = "https://github.com/tonsky/FiraCode/issues/211#issuecomment-239058632";
  };
}
