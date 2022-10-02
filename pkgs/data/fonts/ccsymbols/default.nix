{ lib, fetchurl, unzip }:

let
  pname = "ccsymbols";
  version = "2020-04-19";
in

fetchurl rec {
  name = "${pname}-${version}";

  url = "https://www.ctrl.blog/file/${version}_cc-symbols.zip";
  sha256 = "sha256-mrNgTS6BAVJrIz9fHOjf8pkSbZtZ55UjyoL9tQ1fiA8=";
  recursiveHash = true;

  nativeBuildInputs = [ unzip ];

  downloadToTemp = true;
  postFetch = ''
    mkdir -p "$out/share/fonts/ccsymbols"
    unzip -d "$out/share/fonts/ccsymbols" "$downloadedFile"
  '';

  passthru = { inherit pname version; };

  meta = with lib; {
    description = "Creative Commons symbol font";
    homepage = "https://www.ctrl.blog/entry/creative-commons-unicode-fallback-font.html";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.publicDomain;
    platforms = platforms.all;
  };
}
