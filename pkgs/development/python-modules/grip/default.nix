{ lib
, fetchFromGitHub
# Python bits:
, buildPythonPackage
, pytest
, responses
, docopt
, flask
, markdown
, path-and-address
, pygments
, requests
, tabulate
}:

buildPythonPackage rec {
  pname = "grip";
  version = "4.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "joeyespo";
    repo = "grip";
    rev = "v${version}";
    hash = "sha256-CHL2dy0H/i0pLo653F7aUHFvZHTeZA6jC/rwn1KrEW4=";
  };

  nativeCheckInputs = [ pytest responses ];

  propagatedBuildInputs = [ docopt flask markdown path-and-address pygments requests tabulate ];

  checkPhase = ''
      export PATH="$PATH:$out/bin"
      py.test -xm "not assumption"
  '';

  meta = with lib; {
    description = "Preview GitHub Markdown files like Readme locally before committing them";
    homepage = "https://github.com/joeyespo/grip";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
