{ lib
, python
, fetchPypi
, buildPythonPackage
, postgresql
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "pgsanity";
  version = "0.2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de0bbd6fe4f98bf5139cb5f466eac2e2abaf5a7b050b9e4867b87bf360873173";
  };

  nativeCheckInputs = [ unittestCheckHook postgresql ];
  propagatedBuildInputs = [ postgresql ];

  meta = with lib; {
    homepage = "https://github.com/markdrago/pgsanity";
    description = "Checks the syntax of Postgresql SQL files";
    longDescription = ''
      PgSanity checks the syntax of Postgresql SQL files by
      taking a file that has a list of bare SQL in it,
      making that file look like a C file with embedded SQL,
      run it through ecpg and
      let ecpg report on the syntax errors of the SQL.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ nalbyuites ];
  };
}
