{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "param";
  version = "1.12.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "holoviz";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-XVHYx0M/BLjNNneObxygPHtid65ti7nctKsUMF21fmw=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # Version is not set properly
    substituteInPlace setup.py \
      --replace 'version=get_setup_version("param"),' 'version="${version}",'
  '';

  pythonImportsCheck = [
    "param"
  ];

  meta = with lib; {
    description = "Declarative Python programming using Parameters";
    homepage = "https://github.com/pyviz/param";
    changelog = "https://github.com/holoviz/param/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
