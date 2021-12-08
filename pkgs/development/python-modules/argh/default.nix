{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, py
, mock
, glibcLocales
, iocapture
}:

buildPythonPackage rec {
  pname = "argh";
  version = "0.26.2";

  src = fetchFromGitHub {
     owner = "neithere";
     repo = "argh";
     rev = "v0.26.2";
     sha256 = "1829wivrzi0an7aai07cfc0arsrzjk2dh6mc4phf2s44q6vacb9k";
  };

  checkInputs = [ pytest py mock glibcLocales iocapture ];

  checkPhase = ''
    export LANG="en_US.UTF-8"
    py.test
  '';

  meta = with lib; {
    homepage = "https://github.com/neithere/argh/";
    description = "An unobtrusive argparse wrapper with natural syntax";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ domenkozar ];
  };

}
