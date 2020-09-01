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
  version = "2.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hq5biy0mpycbji2mikfbflw4r39prylr47iqhlz234kvwdy0jsg";
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
