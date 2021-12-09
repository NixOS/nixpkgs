{ lib, fetchFromGitHub, buildPythonPackage, isPy3k, future }:

buildPythonPackage rec {
  pname = "ECPy";
  version = "1.2.5";

  src = fetchFromGitHub {
     owner = "ubinity";
     repo = "ECPy";
     rev = "1.2.5";
     sha256 = "0p642bpqicxjkwqk4q46wqkbxhad1qiir6xz4w7xx0d4cdq7yps8";
  };

  prePatch = ''
    sed -i "s|reqs.append('future')|pass|" setup.py
  '';

  propagatedBuildInputs = lib.optional (!isPy3k) future;

  # No tests implemented
  doCheck = false;

  pythonImportsCheck = [ "ecpy" ];

  meta = with lib; {
    description = "Pure Pyhton Elliptic Curve Library";
    homepage = "https://github.com/ubinity/ECPy";
    license = licenses.asl20;
  };
}
