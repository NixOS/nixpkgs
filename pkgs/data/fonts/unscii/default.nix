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
  nativeBuildInputs = [perl bdftopcf perlPackages.TextCharWidth fontforge
    SDL SDL_image];
  preConfigure = ''
    patchShebangs .
  '';
  installPhase = ''
    install -m444 -Dt $out/share/fonts          *.hex *.pcf
    install -m444 -Dt $out/share/fonts/truetype *.ttf
    install -m444 -Dt $out/share/fonts/opentype *.otf
    install -m444 -Dt $out/share/fonts/svg      *.svg
    install -m444 -Dt $out/share/fonts/web      *.woff
  '';

  meta = {
    inherit version;
    description = ''Bitmapped character-art-friendly Unicode fonts'';
    # Basically GPL2+ with font exception — because of the Unifont-augmented
    # version. The reduced version is public domain.
    license = http://unifoundry.com/LICENSE.txt;
    maintainers = [stdenv.lib.maintainers.raskin];
    homepage = http://pelulamu.net/unscii/;
  };
}
