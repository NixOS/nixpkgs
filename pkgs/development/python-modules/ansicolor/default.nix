{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "ansicolor";
  version = "0.3.2";

  src = fetchFromGitHub {
     owner = "numerodix";
     repo = "ansicolor";
     rev = "0.3.2";
     sha256 = "1q5qahpvva9wdh5mv3a4a6iazx4jrdmc41ny1dyc8z40im9l1w3b";
  };

  meta = with lib; {
    homepage = "https://github.com/numerodix/ansicolor/";
    description = "A library to produce ansi color output and colored highlighting and diffing";
    license = licenses.asl20;
    maintainers = with maintainers; [ andsild ];
  };
}
