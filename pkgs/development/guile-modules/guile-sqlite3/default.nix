{ lib
, mkGuileModule
, fetchgit
, libffi
, sqlite
}:

mkGuileModule rec {
  pname = "guile-sqlite3";
  version = "0.1.0";

  src = fetchgit {
    url = "https://notabug.org/civodul/${pname}.git";
    rev = "v${version}";
    sha256 = "1nv8j7wk6b5n4p22szyi8lv8fs31rrzxhzz16gyj8r38c1fyp9qp";
  };

  buildInputs = [
    libffi
    sqlite
  ];

  meta = with lib; {
    description = "sqlite3 bindings for Guile";
    homepage = "https://notabug.org/civodul/guile-sqlite3";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}
