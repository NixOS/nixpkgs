{
  pkgs,
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pillow,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "pydyf";
  version = "0.13.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PBvVNscWHZ9HK4KoqqJ9M1mpBY7BLeFTAtkrNpDa5/U=";
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

  meta = {
    description = "Low-level PDF generator written in Python and based on PDF specification 1.7";
    homepage = "https://doc.courtbouillon.org/pydyf/stable/";
    changelog = "https://github.com/CourtBouillon/pydyf/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rprecenth ];
  };
}
