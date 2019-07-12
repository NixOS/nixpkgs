{ buildPythonPackage, fetchPypi
, click, typed-ast, lib
}:

buildPythonPackage rec {
  pname = "retype";
  version = "17.12.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "09xkr6h7fmhr3r3jzbhv8d6gq1zzpgbbffk033cmyvxyxxxpcjxn";
  };

  propagatedBuildInputs = [ click typed-ast ];

  meta = with lib; {
    description = "Re-apply type annotations from .pyi stubs to your codebase";
    license = licenses.mit;
    homepage = https://github.com/ambv/retype;
    maintainers = with maintainers; [ mredaelli ];
  };
}
