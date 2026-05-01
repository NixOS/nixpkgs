{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  cocotb-bus,
  find-libpython,
  pytestCheckHook,
  swig,
  iverilog,
  ghdl,
  stdenv,
}:

buildPythonPackage rec {
  pname = "cocotb";
  version = "2.0.0";
  format = "setuptools";

  # pypi source doesn't include tests
  src = fetchFromGitHub {
    owner = "cocotb";
    repo = "cocotb";
    tag = "v${version}";
    hash = "sha256-BpshczKA83ZeytGDrHEg6IAbI5FxciAUnzwE10hgPC0=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ find-libpython ];

  postPatch = ''
    patchShebangs bin/*.py

    # POSIX portability (TODO: upstream this)
    for f in \
      cocotb/share/makefiles/Makefile.* \
      cocotb/share/makefiles/simulators/Makefile.*
    do
      substituteInPlace $f --replace 'shell which' 'shell command -v'
    done

    # remove circular dependency cocotb-bus from setup.py
    substituteInPlace setup.py --replace "'cocotb-bus<1.0'" ""
  '';

  disabledTests = [
    # https://github.com/cocotb/cocotb/commit/425e1edb8e7133f4a891f2f87552aa2748cd8d2c#diff-4df986cbc2b1a3f22172caea94f959d8fcb4a128105979e6e99c68139469960cL33
    "test_cocotb"
    "test_cocotb_parallel"
  ];

  nativeCheckInputs = [
    cocotb-bus
    pytestCheckHook
    swig
    iverilog
    ghdl
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "cocotb" ];

  meta = {
    changelog = "https://github.com/cocotb/cocotb/releases/tag/v${version}";
    description = "Coroutine based cosimulation library for writing VHDL and Verilog testbenches in Python";
    mainProgram = "cocotb-config";
    homepage = "https://github.com/cocotb/cocotb";
    license = lib.licenses.bsd3;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [
      matthuszagh
      jleightcap
    ];
  };
}
