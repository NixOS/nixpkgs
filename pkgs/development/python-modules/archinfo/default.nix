{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, nose
}:

buildPythonPackage rec {
  pname = "archinfo";
  version = "9.0.10534";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8bGDl3rHVT2JKEOfYPHzFTxJ7t3Yz7aLQMVKAUNCSBo=";
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
