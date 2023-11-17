{ lib
, stdenv
, buildPythonPackage
, isPyPy
, fetchPypi
, setuptools
, pytestCheckHook
, libffi
, pkg-config
, pycparser
, pythonAtLeast
}:

if isPyPy then null else buildPythonPackage rec {
  pname = "cffi";
  version = "1.16.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vLPvQ+WGZbvaL7GYaY/K5ndkg+DEpjGqVkeAbCXgLMA=";
  };

  patches = [
    #
    # Trusts the libffi library inside of nixpkgs on Apple devices.
    #
    # Based on some analysis I did:
    #
    #   https://groups.google.com/g/python-cffi/c/xU0Usa8dvhk
    #
    # I believe that libffi already contains the code from Apple's fork that is
    # deemed safe to trust in cffi.
    #
    ./darwin-use-libffi-closures.diff
  ] ++ lib.optionals (stdenv.cc.isClang && lib.versionAtLeast (lib.getVersion stdenv.cc) "13") [
    # -Wnull-pointer-subtraction is enabled with -Wextra. Suppress it to allow the following tests
    # to run and pass when cffi is built with newer versions of clang:
    # - testing/cffi1/test_verify1.py::test_enum_usage
    # - testing/cffi1/test_verify1.py::test_named_pointer_as_argument
    ./clang-pointer-substraction-warning.diff
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    # Remove setup.py impurities
    substituteInPlace setup.py \
      --replace "'-iwithsysroot/usr/include/ffi'" "" \
      --replace "'/usr/include/ffi'," "" \
      --replace '/usr/include/libffi' '${lib.getDev libffi}/include'
  '';

  nativeBuildInputs = [
    pkg-config
    setuptools
  ];

  buildInputs = [
    libffi
  ];

  propagatedBuildInputs = [
    pycparser
  ];

  # The tests use -Werror but with python3.6 clang detects some unreachable code.
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang
    "-Wno-unused-command-line-argument -Wno-unreachable-code -Wno-c++11-narrowing";

  doCheck = !stdenv.hostPlatform.isMusl;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/python-cffi/cffi/releases/tag/v${version}";
    description = "Foreign Function Interface for Python calling C code";
    downloadPage = "https://github.com/python-cffi/cffi";
    homepage = "https://cffi.readthedocs.org/";
    license = licenses.mit;
    maintainers = teams.python.members;
  };
}
