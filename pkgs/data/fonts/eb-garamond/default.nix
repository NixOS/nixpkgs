{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "eb-garamond";
  version = "0.016";

  src = fetchzip {
    url = "https://bitbucket.org/georgd/eb-garamond/downloads/EBGaramond-${version}.zip";
    sha256 = "0j40bg1di39q7zis64il67xchldyznrl8wij9il10c4wr8nl4r9z";
  };

  meta = with lib; {
    homepage = "http://www.georgduffner.at/ebgaramond/";
    description = "Digitization of the Garamond shown on the Egenolff-Berner specimen";
    maintainers = with maintainers; [ relrod rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
