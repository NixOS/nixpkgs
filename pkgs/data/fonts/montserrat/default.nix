# Originally packaged for ArchLinux.
#
# https://aur.archlinux.org/packages/ttf-montserrat/

{ stdenv, fetchzip }:

let
  version = "1.0";
in fetchzip {
  name = "montserrat-${version}";

  url = "http://marvid.fr/~eeva/mirror/Montserrat.tar.gz";

  postFetch = ''
    tar -xzf $downloadedFile --strip-components=1
    mkdir -p $out/share/fonts/montserrat
    cp *.ttf $out/share/fonts/montserrat
  '';

  sha256 = "11sdgvhaqg59mq71aqwqp2mb428984hjxy7hd1vasia9kgk8259w";

  meta = with stdenv.lib; {
    description = "A geometric sans serif font with extended latin support (Regular, Alternates, Subrayada)";
    homepage    = "http://www.fontspace.com/julieta-ulanovsky/montserrat";
    license     = licenses.ofl;
    platforms   = platforms.all;
    maintainers = with maintainers; [ scolobb ];
  };
}
