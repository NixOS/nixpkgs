{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "rope";
  version = "0.10.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lc01pjn0yr6yqcpbf6kk170zg8zhnyzj8kqlsch1mag0g9dz7m0";
  };

  meta = with stdenv.lib; {
    description = "Python refactoring library";
    homepage = https://github.com/python-rope/rope;
    maintainers = with maintainers; [ goibhniu ];
    license = licenses.gpl2;
  };
}
