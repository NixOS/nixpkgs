{
  pkgs,
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pillow,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pydyf";
  version = "0.12.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+9fnWVQaxyXCnFBmEgA945Mkm5QxDqeK5Eyx0EsiAJU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--isort --flake8" ""
  '';

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [
    pkgs.ghostscript
    pillow
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "pydyf" ];

  meta = with lib; {
    description = "Low-level PDF generator written in Python and based on PDF specification 1.7";
    homepage = "https://doc.courtbouillon.org/pydyf/stable/";
    changelog = "https://github.com/CourtBouillon/pydyf/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rprecenth ];
  };
}
