{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "colorlover";
  version = "0.3.0";

  src = fetchFromGitHub {
     owner = "jackparmer";
     repo = "colorlover";
     rev = "v0.3.0";
     sha256 = "1zqc92hj0h9h8aijxb68gz3nv78zv3fzihwy7jyi57bxarfc5jp7";
  };

  # no tests included in distributed archive
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jackparmer/colorlover";
    description = "Color scales in Python for humans";
    license = licenses.mit;
    maintainers = with maintainers; [ globin ];
  };
}
