{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, requests }:

buildPythonPackage rec {
  pname = "pyupdate";
  version = "1.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qxbakhsgmdc5aakhkadr26dlhi0lma7170b245sragn170fqjxf";
  };

  propagatedBuildInputs = [ requests ];

  # As of 0.2.16, pyupdate is intimately tied to Home Assistant which is py3 only
  disabled = !isPy3k;

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    # This description is terrible, but it's what upstream uses.
    description = "Package to update stuff";
    homepage = https://github.com/ludeeus/pyupdate;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
