{ lib, fetchFromGitHub }:

let version = "0.5.3";
in fetchFromGitHub rec {
  name = "ibm-plex-${version}";

  owner = "IBM";
  repo = "type";
  rev = "v${version}";
  sha256 = "1im7sid3qsk4wnm0yhq9h7i50bz46jksqxv60svdfnsrwq0krd1h";

  postFetch = ''
    tar --strip-components=1 -xzvf $downloadedFile
    mkdir -p $out/share/fonts/opentype
    cp fonts/*/desktop/mac/*.otf $out/share/fonts/opentype/
  '';

  meta = with lib; {
    description = "IBM Plex Typeface";
    homepage = https://ibm.github.io/type/;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
