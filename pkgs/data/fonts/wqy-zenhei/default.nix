{ stdenv, fetchzip }:

let
  version = "0.9.45";
in fetchzip rec {
  name = "wqy-zenhei-${version}";

  url = "mirror://sourceforge/wqy/${name}.tar.gz";

  postFetch = ''
    tar -xzf $downloadedFile --strip-components=1
    mkdir -p $out/share/fonts
    install -m644 *.ttc $out/share/fonts/
  '';

  sha256 = "0hbjq6afcd63nsyjzrjf8fmm7pn70jcly7fjzjw23v36ffi0g255";

  meta = {
    description = "A (mainly) Chinese Unicode font";
    homepage = http://wenq.org;
    license = stdenv.lib.licenses.gpl2; # with font embedding exceptions
    maintainers = [ stdenv.lib.maintainers.pkmx ];
    platforms = stdenv.lib.platforms.all;
  };
}
