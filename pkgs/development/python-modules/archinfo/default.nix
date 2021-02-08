{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, nose
}:

buildPythonPackage rec {
  pname = "archinfo";
  version = "9.0.5610";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YlqCRLx8mqHXMKPCWqcGvHxRBGOxbwMZWPEDX/jEDdI=";
  };

  checkInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "archinfo" ];

  meta = with lib; {
    description = "Classes with architecture-specific information";
    homepage = "https://github.com/angr/archinfo";
    license = with licenses; [ bsd2 ];
    maintainers = [ maintainers.fab ];
  };
}
