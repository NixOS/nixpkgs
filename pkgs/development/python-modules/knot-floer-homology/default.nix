{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
}:

buildPythonPackage rec {
  pname = "knot-floer-homology";
  version = "1.2.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "knot_floer_homology";
    tag = "${version}_as_released";
    hash = "sha256:1np0qq9g6jrsld53gp7lailzybw12mzm04g12drk0mcl0vs683qv";
  };

  build-system = [
    setuptools
    cython
  ];

  pythonImportsCheck = [ "knot_floer_homology" ];

  meta = with lib; {
    description = "Python wrapper for Zoltán Szabó's HFK Calculator";
    homepage = "https://github.com/3-manifolds/knot_floer_homology";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ noiioiu ];
  };
}
