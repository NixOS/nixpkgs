{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, pytest }:

buildPythonPackage rec {
  pname = "pastel";
  version = "0.1.0";

  # No tests in PyPi tarball
  src = fetchFromGitHub {
    owner = "sdispater";
    repo = "pastel";
    rev = version;
    sha256 = "1b4ag7jr7j0sxly5g29imdq8g0d4ixhbck55dblr45mlsidydx0s";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    pytest tests -sq
  '';

  meta = with lib; {
    homepage = https://github.com/sdispater/pastel;
    description = "Bring colors to your terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
