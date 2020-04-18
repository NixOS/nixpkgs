{ stdenv, buildPythonPackage, pythonOlder, fetchFromGitHub, pytest, requests }:

buildPythonPackage rec {
  pname = "fritzconnection";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "kbr";
    repo = pname;
    rev = version;
    hash = "sha256:17z4shs56ci9mxmilppv5xy9gbnbp6p1h2ms6x55nkvwndacrp7x";
  };

  disabled = pythonOlder "3.5";

  # Exclude test files from build, which cause ImportMismtachErrors and
  # otherwise missing resources during tests. This patch can be dropped once
  # https://github.com/kbr/fritzconnection/pull/39 is merged.
  prePatch = ''
    substituteInPlace setup.py \
      --replace 'find_packages()' 'find_packages(exclude=["*.tests"])'
  '';

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "Python-Tool to communicate with the AVM FritzBox using the TR-064 protocol";
    homepage = "https://bitbucket.org/kbr/fritzconnection";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda valodim ];
  };
}
