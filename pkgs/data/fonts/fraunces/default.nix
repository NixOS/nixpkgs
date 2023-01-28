# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:
let
  version = "1.000";
in
(fetchzip {
  name = "fraunces-${version}";

  url = "https://github.com/undercasetype/Fraunces/releases/download/${version}/UnderCaseType_Fraunces_${version}.zip";

  sha256 = "0qgl140qkn9p87x7pk60fd3lj206y5h0fq2xkcj2qiv3sxbqxwqb";

  meta = with lib; {
    description = "A display, “Old Style” soft-serif typeface inspired by early 20th century typefaces";
    homepage = "https://github.com/undercasetype/Fraunces";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';
})
