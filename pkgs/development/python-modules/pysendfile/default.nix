{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pysendfile";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UQpBSycJhvujx5y3bZCkyRDHAb+0P/mDpdTpKEYFDhc=";
  };

  build-system = [ setuptools ];

  # Tests depend on asynchat and asyncore
  doCheck = false;

  pythonImportsCheck = [ "sendfile" ];

  meta = with lib; {
    description = "Python interface to sendfile(2)";
    homepage = "https://github.com/giampaolo/pysendfile";
    changelog = "https://github.com/giampaolo/pysendfile/blob/release-${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    broken = stdenv.isDarwin;
  };
}
