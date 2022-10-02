{ lib, stdenv, fetchzip }:

stdenv.mkDerivation {
  pname = "cooper-hewitt";
  version = "unstable-2014-06-09";

  src = fetchzip {
    url = "https://www.cooperhewitt.org/wp-content/uploads/fonts/CooperHewitt-OTF-public.zip";
    hash = "sha256-bTlEXQeYNNspvnNdvQhJn6CNBrcSKYWuNWF/N6+3Vb0=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -D -m 644 -t "$out/share/fonts/opentype" *.otf
  '';

  meta = with lib; {
    homepage = "https://www.cooperhewitt.org/open-source-at-cooper-hewitt/cooper-hewitt-the-typeface-by-chester-jenkins/";
    description = "A contemporary sans serif, with characters composed of modified-geometric curves and arches";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
