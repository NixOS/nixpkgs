{stdenv, fetchurl, perl, bdftopcf, perlPackages, fontforge, SDL, SDL_image}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "unscii";
  version = "1.1";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "http://pelulamu.net/${pname}/${name}-src.tar.gz";
    sha256 = "0qcxcnqz2nlwfzlrn115kkp3n8dd7593h762vxs6vfqm13i39lq1";
  };
  buildInputs = [];
  nativeBuildInputs = [perl bdftopcf perlPackages.TextCharWidth fontforge 
    SDL SDL_image];
  preConfigure = ''
    patchShebangs .
  '';
  installPhase = ''
    mkdir -p "$out/share/fonts"/{truetype,opentype,web,svg}
    cp *.hex "$out/share/fonts/"
    cp *.pcf "$out/share/fonts/"
    cp *.ttf "$out/share/fonts/truetype"
    cp *.otf "$out/share/fonts/opentype"
    cp *.svg "$out/share/fonts/svg"
    cp *.woff "$out/share/fonts/web"
  '';
  meta = {
    inherit version;
    description = ''Bitmapped character-art-friendly Unicode fonts'';
    # Basically GPL2+ with font exception — because of the Unifont-augmented
    # version. The reduced version is public domain.
    license = http://unifoundry.com/LICENSE.txt;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://pelulamu.net/unscii/;
  };
}
