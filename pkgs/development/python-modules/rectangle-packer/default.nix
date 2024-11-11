{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  cython,
}:

buildPythonPackage rec {
  pname = "rectangle-packer";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Penlect";
    repo = pname;
    rev = version;
    hash = "sha256-YsMLB9jfAC5yB8TnlY9j6ybXM2ILireOgQ8m8wYo4ts=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'Cython<3.0.0' 'Cython'
  '';

  pythonImportsCheck = [ "rpack" ];

  meta = with lib; {
    description = "Pack a set of rectangles into a bounding box with minimum area";
    homepage = "https://github.com/Penlect/rectangle-packer";
    license = licenses.mit;
    maintainers = [ ];
  };
}
