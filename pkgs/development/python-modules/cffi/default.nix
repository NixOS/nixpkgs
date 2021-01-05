{ stdenv, buildPythonPackage, isPyPy, fetchPypi, libffi, pycparser, pytestCheckHook }:

if isPyPy then null else buildPythonPackage rec {
  pname = "cffi";
  version = "1.14.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a465cbe98a7fd391d47dce4b8f7e5b921e6cd805ef421d04f5f66ba8f06086c";
  };

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ libffi pycparser ];
  checkInputs = [ pytestCheckHook ];

  # On Darwin, the cffi tests want to hit libm a lot, and look for it in a global
  # impure search path. It's obnoxious how much repetition there is, and how difficult
  # it is to get it to search somewhere else (since we do actually have a libm symlink in libSystem)
  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace testing/cffi0/test_parsing.py \
      --replace 'lib_m = "m"' 'lib_m = "System"' \
      --replace '"libm" in name' '"libSystem" in name'
    substituteInPlace testing/cffi0/test_unicode_literals.py --replace 'lib_m = "m"' 'lib_m = "System"'
    substituteInPlace testing/cffi0/test_zdistutils.py --replace 'self.lib_m = "m"' 'self.lib_m = "System"'
    substituteInPlace testing/cffi1/test_recompiler.py --replace 'lib_m = "m"' 'lib_m = "System"'
    substituteInPlace testing/cffi0/test_function.py --replace "lib_m = 'm'" "lib_m = 'System'"
    substituteInPlace testing/cffi0/test_verify.py --replace "lib_m = ['m']" "lib_m = ['System']"
  '';

  # The tests use -Werror but with python3.6 clang detects some unreachable code.
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isClang
    "-Wno-unused-command-line-argument -Wno-unreachable-code";

  doCheck = !stdenv.hostPlatform.isMusl && !stdenv.isDarwin; # TODO: Investigate
  disabledTests = [
    # unix gets mistaken as windows because find_library returns None
    "test_load_FILE"
    "test_FILE"
    "test_load_library"
    "test_load_and_call_function"
    "test_read_variable"
    "test_load_read_variable"
    "test_write_variable"
    "windows"
    # these tests assume glibc dlopen behavior, and assert that they were able
    # to find a library using normal dlopen conventions. However,
    # this behavior of ctypes.utils.find_library is disabled in nixpkgs
    "test_sin"
    "dlopen"
    "dlclose"
    "test_function_typedef"
    "test_missing_function"
    "test_wraps_from_stdlib"
    "test_remove_comments"
    "line_continuation"
    "test_simple"
  ];

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ jonringer domenkozar lnl7 ];
    homepage = "https://cffi.readthedocs.org/";
    license = with licenses; [ mit ];
    description = "Foreign Function Interface for Python calling C code";
  };
}
