{ lib
, angr
, buildPythonPackage
, fetchFromGitHub
, progressbar
, pythonOlder
}:

buildPythonPackage rec {
  pname = "angrop";
  version = "9.0.6790";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    sha256 = "16r22ajkj8sxbgsym0i85xdjvphgf1566p5s7d915kkj37qdrrpy";
  };

  propagatedBuildInputs = [
    angr
    progressbar
  ];

  # Tests have additional requirements, e.g., angr binaries
  # cle is executing the tests with the angr binaries already and is a requirement of angr
  doCheck = false;
  pythonImportsCheck = [ "angrop" ];

  meta = with lib; {
    description = "ROP gadget finder and chain builder";
    homepage = "https://github.com/angr/angrop";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
