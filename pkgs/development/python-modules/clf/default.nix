{ lib, buildPythonPackage, fetchPypi
, docopt, requests, pygments }:

buildPythonPackage rec {
  pname = "clf";
  version = "0.5.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "abc919a1e99667f32fdde15dfb4bc527dbe22cf86a17acb78a449d7f2dfe937e";
  };

  patchPhase = ''
    sed -i 's/==/>=/' requirements.txt
  '';

  propagatedBuildInputs = [ docopt requests pygments ];

  # Error when running tests:
  # No local packages or download links found for requests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ncrocfer/clf";
    description = "Command line tool to search snippets on Commandlinefu.com";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
