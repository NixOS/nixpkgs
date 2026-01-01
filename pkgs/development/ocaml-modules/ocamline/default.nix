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

<<<<<<< HEAD
  meta = {
    homepage = "https://chrisnevers.github.io/ocamline/";
    description = "Command line interface for user input";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mgttlinger ];
=======
  meta = with lib; {
    homepage = "https://chrisnevers.github.io/ocamline/";
    description = "Command line interface for user input";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mgttlinger ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
