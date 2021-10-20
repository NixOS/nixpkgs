{ lib
, stdenv
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
  # Python requirements
, cython
, dill
, fastjsonschema
, jsonschema
, numpy
, networkx
, ply
, psutil
, python-constraint
, python-dateutil
, retworkx
, scipy
, sympy
, withVisualization ? false
  # Python visualization requirements, optional
, ipywidgets
, matplotlib
, pillow
, pydot
, pygments
, pylatexenc
, seaborn
  # Crosstalk-adaptive layout pass
, withCrosstalkPass ? false
, z3
  # Classical function -> Quantum Circuit compiler
, withClassicalFunctionCompiler ? true
, tweedledum
  # test requirements
, ddt
, hypothesis
, nbformat
, nbconvert
, pytestCheckHook
, python
}:

let
  visualizationPackages = [
    ipywidgets
    matplotlib
    pillow
    pydot
    pygments
    pylatexenc
    seaborn
  ];
  crosstalkPackages = [ z3 ];
  classicalCompilerPackages = [ tweedledum ];
in

buildPythonPackage rec {
  pname = "qiskit-terra";
  version = "0.17.4";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = version;
    hash = "sha256-JyNuke+XPqjLVZbvPud9Y7k0+EmvETVKcOYcDldBiVo=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    dill
    fastjsonschema
    jsonschema
    numpy
    networkx
    ply
    psutil
    python-constraint
    python-dateutil
    retworkx
    scipy
    sympy
  ] ++ lib.optionals withVisualization visualizationPackages
  ++ lib.optionals withCrosstalkPass crosstalkPackages
  ++ lib.optionals withClassicalFunctionCompiler classicalCompilerPackages;

  # *** Tests ***
  checkInputs = [
    pytestCheckHook
    ddt
    hypothesis
    nbformat
    nbconvert
  ] ++ lib.optionals (!withVisualization) visualizationPackages;

  pythonImportsCheck = [
    "qiskit"
    "qiskit.transpiler.passes.routing.cython.stochastic_swap.swap_trial"
  ];

  disabledTestPaths = [
    "test/randomized/test_transpiler_equivalence.py" # collection requires qiskit-aer, which would cause circular dependency
  ] ++ lib.optionals (!withClassicalFunctionCompiler) [
    "test/python/classical_function_compiler/"
  ];
  disabledTests = [
    # Not working on matplotlib >= 3.4.0, checks images match.
    "test_plot_circuit_layout"

    # Flaky tests
    "test_cx_equivalence"
    "test_pulse_limits"
    "test_1q_random"
  ] ++ lib.optionals (!withClassicalFunctionCompiler) [
    "TestPhaseOracle"
  ] ++ lib.optionals stdenv.isAarch64 [
    "test_circuit_init" # failed on aarch64, https://gist.github.com/r-rmcgibbo/c2e173d43ced4f6954811004f6b5b842
  ]
  # Disabling slow tests for build constraints
  ++ [
    "test_all_examples"
    "test_controlled_random_unitary"
    "test_controlled_standard_gates_1"
    "test_jupyter_jobs_pbars"
    "test_lookahead_swap_higher_depth_width_is_better"
    "test_move_measurements"
    "test_job_monitor"
    "test_wait_for_final_state"
    "test_multi_controlled_y_rotation_matrix_basic_mode"
    "test_two_qubit_weyl_decomposition_abc"
    "test_isometry"
    "test_parallel"
    "test_random_state"
    "test_random_clifford_valid"
    "test_to_matrix"
    "test_block_collection_reduces_1q_gate"
    "test_multi_controlled_rotation_gate_matrices"
    "test_block_collection_runs_for_non_cx_bases"
    "test_with_two_qubit_reduction"
    "test_basic_aer_qasm"
    "test_hhl"
    "test_H2_hamiltonian"
    "test_max_evals_grouped_2"
    "test_qaoa_qc_mixer_4"
    "test_abelian_grouper_random_2"
    "test_pauli_two_design"
  ];

  # Moves tests to $PACKAGEDIR/test. They can't be run from /build because of finding
  # cythonized modules and expecting to find some resource files in the test directory.
  preCheck = ''
    export PACKAGEDIR=$out/${python.sitePackages}
    echo "Moving Qiskit test files to package directory"
    cp -r $TMP/$sourceRoot/test $PACKAGEDIR
    cp -r $TMP/$sourceRoot/examples $PACKAGEDIR
    cp -r $TMP/$sourceRoot/qiskit/schemas/examples $PACKAGEDIR/qiskit/schemas/

    # run pytest from Nix's $out path
    pushd $PACKAGEDIR
  '';
  postCheck = ''
    rm -r test
    rm -r examples
    popd
  '';


  meta = with lib; {
    description = "Provides the foundations for Qiskit.";
    longDescription = ''
      Allows the user to write quantum circuits easily, and takes care of the constraints of real hardware.
    '';
    homepage = "https://qiskit.org/terra";
    downloadPage = "https://github.com/QISKit/qiskit-terra/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
