{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  cocotb-bus,
  find-libpython,
  pytestCheckHook,
  swig,
  verilog,
  ghdl,
}:

buildPythonPackage rec {
  pname = "cocotb";
  version = "1.8.1";
  format = "setuptools";

  # pypi source doesn't include tests
  src = fetchFromGitHub {
    owner = "cocotb";
    repo = "cocotb";
    rev = "refs/tags/v${version}";
    hash = "sha256-B7SePM8muEL3KFVOY7+OAgQVIRvTs6k29xASK9lgCB4=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ find-libpython ];

  postPatch =
    ''
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
    ''
    + lib.optionalString stdenv.isDarwin ''
      # disable lto on darwin
      # https://github.com/NixOS/nixpkgs/issues/19098
      substituteInPlace cocotb_build_libs.py --replace "-flto" ""
    '';

  patches = [
    # Fix "can't link with bundle (MH_BUNDLE) only dylibs (MH_DYLIB) file" error
    ./0001-Patch-LDCXXSHARED-for-macOS-along-with-LDSHARED.patch

    # For the 1.8.1 release only: remove the test_unicode_handle_assignment_deprecated test
    # It's more thoroughly removed upstream master with 425e1edb8e7133f4a891f2f87552aa2748cd8d2c
    ./0002-Patch-remove-test_unicode_handle_assignment_deprecated-test.patch
  ];

  nativeCheckInputs = [
    cocotb-bus
    pytestCheckHook
    swig
    verilog
    ghdl
  ];
  preCheck = ''
    export PATH=$out/bin:$PATH
    mv cocotb cocotb.hidden
  '';

  pythonImportsCheck = [ "cocotb" ];

  meta = with lib; {
    changelog = "https://github.com/cocotb/cocotb/releases/tag/v${version}";
    description = "Coroutine based cosimulation library for writing VHDL and Verilog testbenches in Python";
    mainProgram = "cocotb-config";
    homepage = "https://github.com/cocotb/cocotb";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      matthuszagh
      jleightcap
    ];
  };
}
