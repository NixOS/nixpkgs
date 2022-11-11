{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, cocotb-bus
, pytestCheckHook
, swig
, verilog
}:

buildPythonPackage rec {
  pname = "cocotb";
  version = "1.7.1";

  # pypi source doesn't include tests
  src = fetchFromGitHub {
    owner = "cocotb";
    repo = "cocotb";
    rev = "v${version}";
    sha256 = "sha256-wACgT5r0YmSYvLhTsuFhTcJqeCtGGLifOmr7/Lz2Vug=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ setuptools ];

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
  '' + lib.optionalString stdenv.isDarwin ''
    # disable lto on darwin
    # https://github.com/NixOS/nixpkgs/issues/19098
    substituteInPlace cocotb_build_libs.py --replace "-flto" ""
  '';

  patches = [
    # Fix "can't link with bundle (MH_BUNDLE) only dylibs (MH_DYLIB) file" error
    ./0001-Patch-LDCXXSHARED-for-macOS-along-with-LDSHARED.patch
  ];

  checkInputs = [ cocotb-bus pytestCheckHook swig verilog ];
  preCheck = ''
    export PATH=$out/bin:$PATH
    mv cocotb cocotb.hidden
  '';

  pythonImportsCheck = [ "cocotb" ];

  meta = with lib; {
    description = "Coroutine based cosimulation library for writing VHDL and Verilog testbenches in Python";
    homepage = "https://github.com/cocotb/cocotb";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
