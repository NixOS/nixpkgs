{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchFromBitbucket,
  setuptools,
  numpy,
  scipy,
  sympy,
  recursivenodes,
  symengine,
  fenics-ufl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "firdrake-fiat";
  version = "2025.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firedrakeproject";
    repo = "fiat";
    tag = version;
    hash = "sha256-i+hDpeg4SYRF7OK6uh1p1gVscyuJ4FjmyUUiLR7P7/A=";
  };

  postPatch =
    let
      fiat-reference-data = fetchFromBitbucket {
        owner = "fenics-project";
        repo = "fiat-reference-data";
        rev = "0c8c97f7e4919402129e5ff3b54e3f0b9e902b7c";
        hash = "sha256-vdCkmCkKvLSYACF6MnZ/WuKuCNAoC3uu1A/9m9KwBK8=";
      };
    in
    ''
      ln -s ${fiat-reference-data} test/FIAT/regression/fiat-reference-data
    '';

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    sympy
    recursivenodes
    fenics-ufl
    symengine
  ];

  pythonImportsCheck = [
    "FIAT"
    "finat"
    "finat.ufl"
    "gem"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [
    "--skip-download"
  ];

  meta = {
    description = "FInite element Automatic Tabulator";
    homepage = "http://fenics-fiat.readthedocs.org/";
    downloadPage = "https://github.com/firedrakeproject/fiat";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
