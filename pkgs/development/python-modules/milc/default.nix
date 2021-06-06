{ lib
, buildPythonPackage
, fetchFromGitHub
, appdirs
, argcomplete
, colorama
, nose2
, semver
}:

buildPythonPackage rec {
  pname = "milc";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "clueboard";
    repo = "milc";
    rev = version;
    sha256 = "sha256-koyOBz+pB/vkTHOR1p77ACO11/ULDIBzqsszUUpnE88=";
  };

  propagatedBuildInputs = [ appdirs argcomplete colorama ];

  checkInputs = [ nose2 semver ];

  checkPhase = ''
    patchShebangs example hello
    nose2
  '';

  pythonImportsCheck = [ "milc" ];

  meta = with lib; {
    description = "An Opinionated Batteries-Included Python 3 CLI Framework";
    homepage = "https://milc.clueboard.co";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
