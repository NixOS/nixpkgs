{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "blessings";
  version = "1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01rhgn2c3xjf9h1lxij9m05iwf2ba6d0vd7nic26c2gic4q73igd";
  };

  # 4 failing tests, 2to3
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/erikrose/blessings;
    description = "A thin, practical wrapper around terminal coloring, styling, and positioning";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };

}
