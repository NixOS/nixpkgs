{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sphinx,
  tkinter,
}:

buildPythonPackage rec {
  pname = "plink";
  version = "2.4.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = pname;
    rev = "${version}_as_released";
    sha256 = "sha256-+WUyQvQY9Fx47GikzJ4gcCpSIjvk5756FP0bDdF6Ack=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ sphinx ];

  dependencies = [ tkinter ];

  pythonImportsCheck = [ "plink" ];

  meta = with lib; {
    description = "A full featured Tk-based knot and link editor";
    homepage = "https://github.com/3-manifolds/PLink";
    license = licenses.gpl2;
    maintainers = with maintainers; [ noiioiu ];
  };
}
