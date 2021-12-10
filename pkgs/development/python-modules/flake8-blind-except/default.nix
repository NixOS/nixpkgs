{ lib, fetchFromGitHub, buildPythonPackage }:

buildPythonPackage rec {
  pname = "flake8-blind-except";
  version = "0.2.0";
  src = fetchFromGitHub {
     owner = "elijahandrews";
     repo = "flake8-blind-except";
     rev = "v0.2.0";
     sha256 = "1qgfg77x6xgg0db416drak1yw15lpfsg9mfzj7n0qbmh6qbvdw4i";
  };
  meta = {
    homepage = "https://github.com/elijahandrews/flake8-blind-except";
    description = "A flake8 extension that checks for blind except: statements";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.mit;
  };
}
