{ stdenv
, fetchPypi
, buildPythonPackage
, pyparsing
}:

buildPythonPackage rec {
  pname = "PuLP";
  version = "2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06swbi7wygh7y0kxc85q1pdhzk662375d9a5jnahgr76hkwwkybn";
  };

  propagatedBuildInputs = [ pyparsing ];

  # only one test that requires an extra
  doCheck = false;
  pythonImportsCheck = [ "pulp" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/coin-or/pulp";
    description = "PuLP is an LP modeler written in python";
    maintainers = with maintainers; [ teto ];
    license = licenses.mit;
  };
}
