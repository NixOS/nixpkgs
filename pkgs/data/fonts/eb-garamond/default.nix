{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "eb-garamond";
  version = "0.016";

  src = fetchzip {
    url = "https://bitbucket.org/georgd/eb-garamond/downloads/EBGaramond-${version}.zip";
    hash = "sha256-P2VCLcqcMBBoTDJyRLP9vlHI+jE0EqPjPziN2MJbgEg=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 otf/*.otf                                 -t $out/share/fonts/opentype
    install -Dm644 Changes README.markdown README.xelualatex -t $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.georgduffner.at/ebgaramond/";
    description = "Digitization of the Garamond shown on the Egenolff-Berner specimen";
    maintainers = with maintainers; [ relrod rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
