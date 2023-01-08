{ lib
, stdenv
, buildPythonPackage
, isPyPy
, fetchPypi
, pytestCheckHook
, libffi
, pkg-config
, pycparser
}:

if isPyPy then null else buildPythonPackage rec {
  pname = "cffi";
  version = "1.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1AC/uaN7E1ElPLQCZxzqfom97MKU6AFqcH9tHYrJNPk=";
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
  ];

  buildInputs = [ libffi ];

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ pycparser ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    # Remove setup.py impurities
    substituteInPlace setup.py \
      --replace "'-iwithsysroot/usr/include/ffi'" "" \
      --replace "'/usr/include/ffi'," "" \
      --replace '/usr/include/libffi' '${lib.getDev libffi}/include'
  '';

  # The tests use -Werror but with python3.6 clang detects some unreachable code.
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang
    "-Wno-unused-command-line-argument -Wno-unreachable-code -Wno-c++11-narrowing";

  doCheck = !stdenv.hostPlatform.isMusl;

  checkInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # AssertionError: cannot seem to get an int[10] not completely cleared
    # https://foss.heptapod.net/pypy/cffi/-/issues/556
    "test_ffi_new_allocator_1"
  ];

  meta = with lib; {
    maintainers = with maintainers; [ domenkozar lnl7 ];
    homepage = "https://cffi.readthedocs.org/";
    license = licenses.mit;
    description = "Foreign Function Interface for Python calling C code";
  };
}
