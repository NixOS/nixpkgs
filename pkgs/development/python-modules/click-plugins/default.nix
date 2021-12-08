{ lib, buildPythonPackage, fetchFromGitHub,
  click, pytest
}:

buildPythonPackage rec {
  pname = "click-plugins";
  version = "1.1.1";

  src = fetchFromGitHub {
     owner = "click-contrib";
     repo = "click-plugins";
     rev = "1.1.1";
     sha256 = "04bx148n8v656zrx350g4bxw14fsapncdl3kzy6qwydk8x4zir4i";
  };

  propagatedBuildInputs = [
    click
  ];

  checkInputs = [
    pytest
  ];

  meta = with lib; {
    description = "An extension module for click to enable registering CLI commands";
    homepage = "https://github.com/click-contrib/click-plugins";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
