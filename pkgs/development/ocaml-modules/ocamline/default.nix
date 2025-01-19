{
  buildDunePackage,
  linenoise,
  fetchFromGitHub,
  lib,
}:

buildDunePackage rec {
  pname = "ocamline";
  version = "1.2";
  src = fetchFromGitHub {
    owner = "chrisnevers";
    repo = pname;
    rev = version;
    sha256 = "Sljm/Bfr2Eo0d75tmJRuWUkkfHUYQ0g27+FzXBePnVg=";
  };

  propagatedBuildInputs = [ linenoise ];

  meta = {
    homepage = "https://chrisnevers.github.io/ocamline/";
    description = "Command line interface for user input";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mgttlinger ];
  };
}
