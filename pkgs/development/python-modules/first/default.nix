{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "first";
  version = "2.0.2";

  src = fetchFromGitHub {
     owner = "hynek";
     repo = "first";
     rev = "2.0.2";
     sha256 = "0g0ly8b4m5n6kgam0l1nsgiy00v5k8px7cczcpp7v5q9qgqarwlx";
  };

  doCheck = false; # no tests

  meta = with lib; {
    description = "The function you always missed in Python";
    homepage = "https://github.com/hynek/first/";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
