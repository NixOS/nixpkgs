{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  setuptools-scm,

  numpy,
  scipy,
}:

buildPythonPackage rec {
  pname = "pylops";
  version = "2.4.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "V${version}";
    hash = "sha256-8ocZM+4GipqK2BJQJFJgbY7YLLQu6G3LkiZ1HFm1Dl4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "pylops" ];

  meta = with lib; {
    description = "Open-source Python library focused on providing a backend-agnostic, idiomatic, matrix-free library of linear operators and related computations";
    homepage = "https://pylops.readthedocs.io/en/stable/index.html";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
