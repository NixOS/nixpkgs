{ lib
, buildPythonPackage
, fetchPypi
, six
, requests-cache
, pygments
, pyquery
, cachelib
, appdirs
}:

buildPythonPackage rec {
  pname = "howdoi";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b322668606d29d8a841c3b28c0574851f512b55c33a7ceb982b6a98d82fa3e3";
  };

  propagatedBuildInputs = [ six requests-cache pygments pyquery cachelib appdirs ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Instant coding answers via the command line";
    homepage = "https://pypi.python.org/pypi/howdoi";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
