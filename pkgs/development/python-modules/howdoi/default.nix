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
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed8acb75779f598a831224f33fa991c51764872574a128e9b2f11b83fcace010";
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
