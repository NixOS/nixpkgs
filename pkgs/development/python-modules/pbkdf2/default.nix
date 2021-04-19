{ lib, buildPythonPackage, fetchFromPyPI }:

buildPythonPackage rec {
  pname = "pbkdf2";
  version = "1.3";

  src = fetchFromPyPI {
    inherit pname version;
    sha256 = "0yb99rl2mbsaamj571s1mf6vgniqh23v98k4632150hjkwv9fqxc";
  };

  # ImportError: No module named test
  doCheck = false;

  meta = with lib; {
    maintainers = with maintainers; [ domenkozar ];
  };
}
