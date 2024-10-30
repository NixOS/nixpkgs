{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  colorama,
  six,
}:

buildPythonPackage rec {
  pname = "reprint";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Yinzo";
    repo = "reprint";
    rev = "${version}";
    hash = "sha256-99FC12LcvvRRwNAxDSvWo9vRYmieL0JHSaCJqO/UGEs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'backports.shutil_get_terminal_size', " ""
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    colorama
    six
  ];

  pythonImportsCheck = [
    "reprint"
  ];

  meta = {
    description = "Module for binding variables and refreshing multi-line output in terminal";
    homepage = "https://github.com/Yinzo/reprint";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jasonodoom
      jleightcap
    ];
  };
}
