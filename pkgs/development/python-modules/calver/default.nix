{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pretend
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "calver";
  version = "2022.06.26";

  disabled = pythonOlder "3.5";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "di";
    repo = "calver";
    rev = version;
    hash = "sha256-YaXTkeUazwzghCX96Wfx39hGvukWKtHMLLeyF9OeiZI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=calver_version(True)" 'version="${version}"'
  '';

  checkInputs = [
    pretend
    pytestCheckHook
  ];

  pythonImportsCheck = [ "calver" ];

  meta = {
    description = "Setuptools extension for CalVer package versions";
    homepage = "https://github.com/di/calver";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
