{
  lib,
  stdenv,
  fetchPypi,
  buildPythonPackage,
  isPy27,
  pythonAtLeast,
  setuptools,
  numpy,
  scipy,
  matplotlib,
  flask,
  pillow,
  psycopg2,
  tkinter,
  pytestCheckHook,
  pytest-mock,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "ase";
  version = "3.22.1";
  pyproject = true;

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AE32sOoEsRFMeQ+t/kXUEl6w5TElxmqTQlr4U9gqtDI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    matplotlib
    flask
    pillow
    psycopg2
  ] ++ lib.optionals stdenv.isDarwin [
    tkinter
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-xdist
  ];

  disabledTests = [
    "test_fundamental_params"
    "test_ase_bandstructure"
    "test_imports"
    "test_units"
    "test_favicon"
    "test_vibrations_methods" # missing attribute
    "test_jmol_roundtrip" # missing attribute
  ] ++ lib.optionals (pythonAtLeast "3.12") [ "test_info_calculators" ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  pythonImportsCheck = [ "ase" ];

  meta = with lib; {
    description = "Atomic Simulation Environment";
    homepage = "https://wiki.fysik.dtu.dk/ase/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
  };
}
