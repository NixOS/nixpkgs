{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  jinja2,
  numpy,
  pyparsing,
  setuptools,
  sympy,
  pytest,
  pythonOlder,
  pytest-xdist,
  setuptools-scm,
  python,
  scipy,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "brian2";
  version = "2.7.1";
  pyproject = true;

  # https://github.com/python/cpython/issues/117692
  disabled = pythonOlder "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mp1xo6ooYm21s6FYcegQdsHmVgH81usV9IfIM0GM7lc=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/brian-team/brian2/commit/8ed663cafde42cbe2e0171cb19d2217e01676d20.patch";
      hash = "sha256-+s5SJdJmsnee3sWhaj/jwf8RXkfMrLp0aTWF52jLdqU=";
    })
    ./0001-remove-invalidxyz.patch # invalidxyz are reported as error so I remove it
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy>=2.0.0rc1" "numpy"

    substituteInPlace brian2/codegen/cpp_prefs.py \
      --replace-fail "distutils" "setuptools._distutils"
  '';

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    cython
    jinja2
    numpy
    pyparsing
    setuptools
    sympy
    scipy
  ];

  nativeCheckInputs = [
    pytest
    pytest-xdist
  ];

  checkPhase = ''
    runHook preCheck
    # Cython cache lies in home directory
    export HOME=$(mktemp -d)
    cd $HOME && ${python.interpreter} -c "import brian2;assert brian2.test()"
    runHook postCheck
  '';

  meta = {
    description = "Clock-driven simulator for spiking neural networks";
    homepage = "https://briansimulator.org/";
    license = lib.licenses.cecill21;
    maintainers = with lib.maintainers; [ jiegec ];
  };
}
