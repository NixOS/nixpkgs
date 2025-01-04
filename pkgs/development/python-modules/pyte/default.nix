{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  wcwidth,
}:

buildPythonPackage rec {
  pname = "pyte";
  version = "0.8.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "selectel";
    repo = pname;
    rev = version;
    hash = "sha256-u24ltX/LEteiZ2a/ioKqxV2AZgrFmKOHXmySmw21sLE=";
  };

  postPatch = ''
    # Remove pytest-runner dependency since it is not supported in the NixOS
    # sandbox
    sed -i '/pytest-runner/d' setup.py
  '';

  propagatedBuildInputs = [ wcwidth ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyte" ];

  meta = with lib; {
    description = "Simple VTXXX-compatible linux terminal emulator";
    homepage = "https://github.com/selectel/pyte";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ flokli ];
  };
}
