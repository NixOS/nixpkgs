{ lib, fetchzip }:

let
  version = "1.1.5";
in fetchzip rec {
  name = "liberastika-${version}";

  url = "mirror://sourceforge/project/lib-ka/liberastika-ttf-${version}.zip";

  stripRoot = false;

  postFetch = ''
    mkdir -p $out/share/fonts
    install -Dm644 $out/*.ttf -t $out/share/fonts/truetype
    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';

  sha256 = "sha256-1hoETOjPRUIzzM+NUR+g/Ph16jXmH2ARSlZHjgEwoeM=";

  meta = with lib; {
    description = "Liberation Sans fork with improved cyrillic support";
    homepage = "https://sourceforge.net/projects/lib-ka/";

    license = licenses.gpl2;
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = [ ];
  };
}
