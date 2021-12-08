{ buildPythonPackage, pytest, lib, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "affine";
  version = "2.3.0";

  src = fetchFromGitHub {
     owner = "sgillies";
     repo = "affine";
     rev = "2.3.0";
     sha256 = "1nj4sfgm3ri36zaapvpz9k7bwzgc7m569rwgq0p5nhi8f480adv0";
  };

  checkInputs = [ pytest ];
  checkPhase = "py.test";

  meta = with lib; {
    description = "Matrices describing affine transformation of the plane";
    license = licenses.bsd3;
    homepage = "https://github.com/sgillies/affine";
    maintainers = with maintainers; [ mredaelli ];
  };

}
