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
  version = "2.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e4d048ae7ca6182d648f62a66d07360cca2504fe46649c32748b6ef2735f7f4";
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
