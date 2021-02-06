{ lib, buildPythonPackage, fetchgit }:

buildPythonPackage {
  pname = "gusmobile";
  version = "unstable-2020-03-17";

  src = fetchgit {
    url = "https://git.carcosa.net/jmcbray/gusmobile.git";
    rev = "0a09aaaf00578d1389a4aa6b15f5c64867e0f8ca";
    sha256 = "0wpvfk5kj23r83xfha6kidsh5c7y143y9ximlx3h92hih7rpskmn";
  };

  meta = with lib; {
    homepage = "https://git.carcosa.net/jmcbray/gusmobile";
    description = "A simple library for making Gemini protocol requests";
    license = licenses.agpl3;
    maintainers = with maintainers; [ jb55 ];
  };
}
