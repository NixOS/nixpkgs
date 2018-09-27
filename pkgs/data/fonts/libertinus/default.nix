{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "libertinus-${version}";
  version = "6.6";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "khaledhosny";
    repo   = "libertinus";
    sha256 = "0syagjmwy6q1ysncchl9bgyfrm7f6fghj1aipbr6md7l6gafz7ji";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/opentype/
    mkdir -p $out/share/doc/${name}/
    cp *.otf $out/share/fonts/opentype/
    cp *.txt $out/share/doc/${name}/
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "11pxb2zwvjlk06zbqrfv2pgwsl4awf68fak1ks4881i8xbl1910m";

  meta = with stdenv.lib; {
    description = "A fork of the Linux Libertine and Linux Biolinum fonts";
    longDescription = ''
      Libertinus fonts is a fork of the Linux Libertine and Linux Biolinum fonts
      that started as an OpenType math companion of the Libertine font family,
      but grown as a full fork to address some of the bugs in the fonts.
    '';
    homepage = https://github.com/khaledhosny/libertinus;
    license = licenses.ofl;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
  };
}
