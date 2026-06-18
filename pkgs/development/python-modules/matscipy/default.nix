{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  fetchpatch,

  # build-system
  meson-python,
  ninja,
  numpy,

  # dependencies
  ase,
  packaging,
  scipy,

  # optional-dependencies
  # cli:
  argcomplete,
  # dislocation:
  atomman,
  nglview,
  ovito,
  # docs:
  jupytext,
  myst-nb,
  numpydoc,
  pydata-sphinx-theme,
  sphinx,
  sphinx-copybutton,
  sphinx-rtd-theme,
  sphinxcontrib-spelling,

  # tests
  pytest-subtests,
  pytest-timeout,
  pytest-xdist,
  sympy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "matscipy";
  version = "1.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "libAtoms";
    repo = "matscipy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XmY13B5S8tXYiUaec9gL6e0E3bSnbaMteHHiX2ij2sw=";
  };

  patches = [
    # API: Fix compatibility with ASE 3.27.0
    # https://github.com/libAtoms/matscipy/pull/301
    (fetchpatch {
      url = "https://github.com/libAtoms/matscipy/commit/6a91a4646e30796abe51ef3efa4b479d4471aae0.patch";
      hash = "sha256-PH9I+7+nN6fSkugVbxPCs3LqjhP/fQ5NZjiNQ7F70YU=";
    })
    (fetchpatch {
      url = "https://github.com/libAtoms/matscipy/commit/f6478347bbceeab8ec177042b6ed1243e742d55f.patch";
      hash = "sha256-DKk+1TlP+OngcmycsCIE+7s2h/7wa7Gxv9APbuIAoZg=";
    })
  ];

  postPatch =
    # Otherwise the script fails as it can't resolve the version with git
    ''
      substituteInPlace discover_version.py \
        --replace-fail \
          "version = get_version_from_git()" \
          "version = '${finalAttrs.version}'"
    ''
    # Failed: [pytest] section in setup.cfg files is no longer supported, change to [tool:pytest] instead.
    + ''
      substituteInPlace setup.cfg \
        --replace-fail \
          "[pytest]" \
          "[tool:pytest]"
    '';

  build-system = [
    # meson
    meson-python
    ninja
    numpy
  ];

  dependencies = [
    ase
    numpy
    packaging
    scipy
  ];

  optional-dependencies = {
    cli = [
      argcomplete
    ];
    dislocation = [
      atomman
      nglview
      ovito
    ];
    docs = [
      jupytext
      # matscipy
      myst-nb
      numpydoc
      pydata-sphinx-theme
      sphinx
      sphinx-copybutton
      sphinx-rtd-theme
      sphinxcontrib-spelling
    ];
  };

  pythonImportsCheck = [ "matscipy" ];

  nativeCheckInputs = [
    pytest-subtests
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    sympy
  ];

  preCheck = ''
    rm -rf matscipy
  '';

  disabledTestPaths = [
    # The CLI tests look for the source scripts under `../matscipy/cli` relative to the test
    # directory, which we remove in `preCheck` so that tests run against the installed package.
    "tests/test_electrochemistry_cli.py"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # ValueError: cannot resize an array that may be referenced by another object
    "tests/manybody/test_newmb.py"
    "tests/test_neighbours.py"
  ];

  disabledTests = [
    # Numerical assertion failure
    "test_birch_constants"

    # numpy 2 / ase 3.28 incompatibilities in matscipy 1.2.0
    # `ase.phonons` finite-difference reference no longer matches
    "test_hessian_monoatomic"
    "test_hessian_amorphous_alloy"
    "test_hessian_crystalline_alloy"

    # TypeError: only 0-dimensional arrays can be converted to Python scalars
    "test_eam_read_write"

    # AttributeError: 'Log' object has no attribute 'close'
    "test_logger"
    "test_usage"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # AssertionError: assert np.False (numerical precision)
    "test_fixed_line_atoms"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # ValueError: cannot resize an array that may be referenced by another object
    "test_harmonic_bond"
    "test_read_molecules_from_atoms"
    "test_read_molecules_from_lammps_data"
    "test_read_write_lammps_data"
  ];

  meta = {
    description = "Materials science with Python at the atomic-scale";
    homepage = "https://github.com/libAtoms/matscipy";
    changelog = "https://github.com/libAtoms/matscipy/blob/${finalAttrs.src.tag}/ChangeLog.md";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
