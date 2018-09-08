{ lib
, mkGuileModule
, fetchurl
}:

mkGuileModule rec {
  pname = "guile-json";
  version = "1.0.1";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0ls4bws560kkpxvinagsfxpflf1hpapy77fin2khxamcr6fvkl7y";
  };

  meta = with lib; {
    description = "sqlite3 bindings for Guile";
    homepage = "https://notabug.org/civodul/guile-sqlite3";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}
