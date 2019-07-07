{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbkdf2";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yb99rl2mbsaamj571s1mf6vgniqh23v98k4632150hjkwv9fqxc";
  };

  # ImportError: No module named test
  doCheck = false;

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar ];
  };
}
