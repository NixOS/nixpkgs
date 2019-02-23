{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, requests }:

buildPythonPackage rec {
  pname = "pyupdate";
  version = "0.2.29";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0096bde03f43b67c068914ebcb756265641a6d2a5888d4bc81636347c22bf0aa";
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
