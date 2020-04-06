{ stdenv, fetchurl, perl, bdftopcf
, fontforge, SDL, SDL_image, mkfontscale
}:

stdenv.mkDerivation rec {
  pname = "unscii";
  version = "1.1";

  src = fetchurl {
    url = "http://pelulamu.net/${pname}/${pname}-${version}-src.tar.gz";
    sha256 = "0qcxcnqz2nlwfzlrn115kkp3n8dd7593h762vxs6vfqm13i39lq1";
  };

  nativeBuildInputs =
    [ (perl.withPackages (p: [ p.TextCharWidth ]))
      bdftopcf fontforge SDL SDL_image
      mkfontscale
    ];

  preConfigure = ''
    patchShebangs .
  '';

  postBuild = ''
    # compress pcf fonts
    gzip -9 -n *.pcf
  '';

  installPhase = ''
    # install fonts for use in X11 and GTK applications
    install -m444 -Dt "$out/share/fonts/misc"     *.pcf.gz
    install -m444 -Dt "$out/share/fonts/opentype" *.otf
    mkfontdir   "$out/share/fonts/misc"
    mkfontscale "$out/share/fonts/opentype"

    # install other formats in $extra
    install -m444 -Dt "$extra/share/fonts/truetype" *.ttf
    install -m444 -Dt "$extra/share/fonts/svg"      *.svg
    install -m444 -Dt "$extra/share/fonts/web"      *.woff
    install -m444 -Dt "$extra/share/fonts/misc"     *.hex
    mkfontscale "$extra"/share/fonts/*
  '';

  outputs = [ "out" "extra" ];

  meta = {
    inherit version;
    description = ''Bitmapped character-art-friendly Unicode fonts'';
    # Basically GPL2+ with font exception — because of the Unifont-augmented
    # version. The reduced version is public domain.
    license = http://unifoundry.com/LICENSE.txt;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    homepage = http://pelulamu.net/unscii/;
  };
}
