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
  version = "2.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09362f7390119dffd83c61a942801ad4d19aee499340ef7e8d5871167391d3d6";
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
