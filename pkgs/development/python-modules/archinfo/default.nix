{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, nose
}:

buildPythonPackage rec {
  pname = "archinfo";
  version = "9.0.9684";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uRwNvYrea3oexJ3Rcoa9oUMXa+gSnha2K0NM8e/A09k=";
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
