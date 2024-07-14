{
  lib,
  buildPythonPackage,
  fetchPypi,
  docopt,
  requests,
  pygments,
}:

buildPythonPackage rec {
  pname = "clf";
  version = "0.5.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q8kZoemWZ/Mv3eFd+0vFJ9viLPhqF6y3ikSdfy3+k34=";
  };

  patchPhase = ''
    sed -i 's/==/>=/' requirements.txt
  '';

  propagatedBuildInputs = [
    docopt
    requests
    pygments
  ];

  # Error when running tests:
  # No local packages or download links found for requests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ncrocfer/clf";
    description = "Command line tool to search snippets on Commandlinefu.com";
    mainProgram = "clf";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
