{ stdenv, buildPythonPackage, fetchPypi
, docopt, requests, pygments }:

buildPythonPackage rec {
  pname = "clf";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04lqd2i4fjs606b0q075yi9xksk567m0sfph6v6j80za0hvzqyy5";
  };

  patchPhase = ''
    sed -i 's/==/>=/' requirements.txt
  '';

  propagatedBuildInputs = [ docopt requests pygments ];

  # Error when running tests:
  # No local packages or download links found for requests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/ncrocfer/clf;
    description = "Command line tool to search snippets on Commandlinefu.com";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
