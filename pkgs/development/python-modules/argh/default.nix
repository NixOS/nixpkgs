{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, flit-core
, iocapture
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "argh";
  version = "0.28.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sgkwhvDoCaPswktkohRTCe6PVtA0k2zVnlfFWKNXMp0=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  nativeCheckInputs = [
    iocapture
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "argh" ];

  meta = with lib; {
    changelog = "https://github.com/neithere/argh/blob/v${version}/CHANGES";
    homepage = "https://github.com/neithere/argh";
    description = "An unobtrusive argparse wrapper with natural syntax";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ domenkozar ];
  };
}
