{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xafi6ndlm964qj7pnmzmvhp719c8pgs7r7wkr508v3cq2jjw4m6";
  };

  meta = with stdenv.lib; {
    homepage = http://www.buildout.org;
    description = "A software build and configuration system";
    license = licenses.zpl21;
    maintainers = with maintainers; [ garbas ];
  };
}
