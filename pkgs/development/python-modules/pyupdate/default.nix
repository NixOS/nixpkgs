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
    hash = "sha256-AW9QhTtNcuXduWOwQsqkX7YPpNPxOu6BnYKa8h5V7wc=";
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
