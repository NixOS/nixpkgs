{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "csv2md";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "lzakharov";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fyXM88hawO6Q9pwMgVtjXaPVEaP36TOmoYL0c7RFDZ4=";
  };

  meta = {
    homepage = "https://github.com/lzakharov/csv2md";
    description = "Command line tool for converting CSV files into Markdown tables.";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthewcroughan ];
    platforms = lib.platforms.all;
  };
}
