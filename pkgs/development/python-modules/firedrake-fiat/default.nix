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
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "firedrake-fiat";
  version = "2025.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firedrakeproject";
    repo = "fiat";
    tag = version;
    hash = "sha256-x1/gf/QVez6GxPUafxdhxqyT0MkL6w2Qz6VAxRNufdc=";
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

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "([0-9.]+)"
      ];
    };
  };

  meta = {
    description = "FInite element Automatic Tabulator";
    homepage = "http://fenics-fiat.readthedocs.org/";
    downloadPage = "https://github.com/firedrakeproject/fiat";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
