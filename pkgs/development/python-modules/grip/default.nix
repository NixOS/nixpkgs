{ lib
, fetchFromGitHub
# Python bits:
, buildPythonPackage
, pytest
, responses
, flake8
, docopt
, flask
, markdown
, path-and-address
, pygments
, requests
, werkzeug
}:

buildPythonPackage rec {
  pname = "grip";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "joeyespo";
    repo = "grip";
    rev = "v${version}";
    sha256 = "0vhimd99zw7s1fihwr6yfij6ywahv9gdrfcf5qljvzh75mvzcwh8";
  };

  checkInputs = [ pytest responses flake8 ];

  propagatedBuildInputs = [ docopt flask markdown path-and-address pygments requests werkzeug ];

  checkPhase = ''
    runHook preCheck

    export PATH="$PATH:$out/bin"
    py.test -xm "not assumption"

    runHook postCheck
  '';

  meta = with lib; {
    description = "Preview GitHub Markdown files like Readme locally before committing them";
    homepage = "https://github.com/joeyespo/grip";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
