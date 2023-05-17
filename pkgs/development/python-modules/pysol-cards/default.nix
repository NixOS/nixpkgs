{ lib, buildPythonPackage, fetchPypi, six, random2 }:

buildPythonPackage rec {
  pname = "pysol-cards";
  version = "0.14.3";

  src = fetchPypi {
    inherit version;
    pname = "pysol_cards";
    hash = "sha256-sPv9OGFb/G/XVdq1hQWprhYtDaGGbCXKkUGTi1gj8GE=";
  };

  propagatedBuildInputs = [ six random2 ];

  meta = with lib; {
    description = "Generates Solitaire deals";
    homepage = "https://github.com/shlomif/pysol_cards";
    license = licenses.mit;
    maintainers = with maintainers; [ mwolfe ];
  };
}
