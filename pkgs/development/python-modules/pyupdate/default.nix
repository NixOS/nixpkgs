{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  requests,
}:

buildPythonPackage rec {
  pname = "pyupdate";
  version = "1.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "016f50853b4d72e5ddb963b042caa45fb60fa4d3f13aee819d829af21e55ef07";
  };

  propagatedBuildInputs = [ requests ];

  # As of 0.2.16, pyupdate is intimately tied to Home Assistant which is py3 only
  disabled = !isPy3k;

  # no tests
  doCheck = false;

  meta = with lib; {
    # This description is terrible, but it's what upstream uses.
    description = "Package to update stuff";
    homepage = "https://github.com/ludeeus/pyupdate";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
