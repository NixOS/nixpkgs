{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, aiohttp
, rich
}:

buildPythonPackage rec {
  pname = "revup";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JUQqKKIilb5Gl3ZsfXO4OaSoyD/WyfcUkT7x+e4xu0Y=";
  };

  propagatedBuildInputs = [
    aiohttp
    rich
  ];

  meta = with lib; {
    description = "a command-line tool that allow developers to iterate faster on parallel changes and reduce the overhead of creating and maintaining code reviews in Github.";
    homepage = "https://github.com/Skydio/revup";
    license = licenses.mit;
    maintainers = with maintainers; [ dukeofcool199 ];
    mainProgram = "revup";
  };
}
