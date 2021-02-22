{ lib
, buildPythonPackage
, fetchPypi
, six
, pygments
, pyquery
, cachelib
, appdirs
, keep
}:

buildPythonPackage rec {
  pname = "howdoi";
  version = "2.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e561e3c5d4f39ab1f86e9f24bb0b2803ee6e312de61e90907f739aa638f35215";
  };

  postPatch = ''
    substituteInPlace setup.py --replace 'cachelib==0.1' 'cachelib'
  '';

  propagatedBuildInputs = [ six pygments pyquery cachelib appdirs keep ];

  # author hasn't included page_cache directory (which allows tests to run without
  # external requests) in pypi tarball. github repo doesn't have release revisions
  # clearly tagged. re-enable tests when either is sorted.
  doCheck = false;
  preCheck = ''
    mv howdoi _howdoi
    export HOME=$(mktemp -d)
  '';
  pythonImportsCheck = [ "howdoi" ];

  meta = with lib; {
    description = "Instant coding answers via the command line";
    homepage = "https://pypi.python.org/pypi/howdoi";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
