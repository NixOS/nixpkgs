{
  buildPecl,
  lib,
  fetchFromGitHub,
}:

let
<<<<<<< HEAD
  version = "3.5.0";
=======
  version = "3.4.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildPecl {
  inherit version;

  pname = "xdebug";

  src = fetchFromGitHub {
    owner = "xdebug";
    repo = "xdebug";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-RrT79o0eFKwGFq3gIfBWCUy5gFy6odj2AWfsfcGN2R4=";
=======
    hash = "sha256-TxwEyXyUGq3rUWyLExyDopJZ29eAoh9QG1TC2+hImmc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  doCheck = true;

  zendExtension = true;

  meta = {
    changelog = "https://github.com/xdebug/xdebug/releases/tag/${version}";
    description = "Provides functions for function traces and profiling";
    homepage = "https://xdebug.org/";
    license = lib.licenses.php301;
    teams = [ lib.teams.php ];
  };
}
