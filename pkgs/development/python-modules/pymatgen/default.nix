{
  lib,
  ase,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  glibcLocales,
  joblib,
  matplotlib,
  monty,
  networkx,
  oldest-supported-numpy,
  palettable,
  pandas,
  plotly,
  pybtex,
  pydispatcher,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  requests,
  ruamel-yaml,
  scipy,
  seekpath,
  setuptools,
  spglib,
  sympy,
  tabulate,
  uncertainties,
}:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2024.7.18";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "materialsproject";
    repo = "pymatgen";
    rev = "refs/tags/v${version}";
    hash = "sha256-LL3cZO3LkmBuGGcO7dhO2Wtgqx9nxLureFpC8EqvS3M";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cython
    glibcLocales
  ];

  dependencies = [
    matplotlib
    monty
    networkx
    oldest-supported-numpy
    palettable
    pandas
    plotly
    pybtex
    pydispatcher
    requests
    ruamel-yaml
    scipy
    spglib
    sympy
    tabulate
    uncertainties
  ];

  passthru.optional-dependencies = {
    ase = [ ase ];
    joblib = [ joblib ];
    seekpath = [ seekpath ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  preCheck = ''
    # ensure tests can find these
    export PMG_TEST_FILES_DIR="$(realpath ./tests/files)"
    # some tests cover the command-line scripts
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # presumably won't work with our dir layouts
    "test_egg_sources_txt_is_complete"
    # borderline precision failure
    "test_thermal_conductivity"
    # AssertionError
    "test_dict_functionality"
    "test_mean_field"
    "test_potcar_not_found"
    "test_read_write_lobsterin"
    "test_snl"
    "test_unconverged"
  ];

  pythonImportsCheck = [ "pymatgen" ];

  meta = with lib; {
    description = "Robust materials analysis code that defines core object representations for structures and molecules";
    homepage = "https://pymatgen.org/";
    changelog = "https://github.com/materialsproject/pymatgen/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
    broken = true; # tests segfault. that's bad.
  };
}
