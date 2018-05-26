{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "libertinus-${version}";
  version = "6.4";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "khaledhosny";
    repo   = "libertinus";
    sha256 = "0acnq4vpplp2s7kdnhncz61diji3wmhca04g27yqpk03ahb40x9g";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/opentype/
    mkdir -p $out/share/doc/${name}/
    cp *.otf $out/share/fonts/opentype/
    cp *.txt $out/share/doc/${name}/
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0yn526kwb4xjyf6gvf0wflqi45z5dlzicycz2q003a6if5fgqcz3";

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
