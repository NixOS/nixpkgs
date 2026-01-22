{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  python,
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
  version = "2.0.1";
  format = "setuptools";

  # pypi source doesn't include tests
  src = fetchFromGitHub {
    owner = "cocotb";
    repo = "cocotb";
    tag = "v${version}";
    hash = "sha256-LXQNqFlvP+WBaDGWPs5+BXBtW2dhDu+v+7lR/AMG21M=";
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

  # cocotb uses dlopen so that it's dynamic libraries are python version agnostic.
  # Here we patch its dynamic libraries to make sure the correct libpython is found and used.
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    for lib in $out/lib/python*/site-packages/cocotb/libs/*.so; do
      patchelf --add-rpath ${python}/lib --add-needed libpython3.so $lib
    done
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
