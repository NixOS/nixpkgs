{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, llvm
, openmp
, libcxx
, libcxxabi
, typesentry
, blessed
, pytest
}:

buildPythonPackage rec {
  pname = "datatable";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s8z81zffrckvdwrrl0pkjc7gsdvjxw59xgg6ck81dl7gkh5grjk";
  };

  patches = [
    # Disable the compiler monkey patching, and remove the task that's copying
    # the native dependencies to the build directory.
    ./remove-compiler-monkeypatch_disable-native-relocation.patch
  ] ++ lib.optionals stdenv.isDarwin [
    # Replace the library auto-detection with hardcoded paths. These paths are
    # then replaced by the following postPatch.
    ./hardcode-library-paths.patch
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace ci/setup_utils.py \
      --subst-var-by libomp.dylib ${lib.getLib openmp}/lib/libomp.dylib \
      --subst-var-by libc++.1.dylib ${lib.getLib libcxx}/lib/libc++.1.dylib \
      --subst-var-by libc++abi.dylib ${lib.getLib libcxxabi}/lib/libc++abi.dylib
  '';

  disabled = pythonOlder "3.5";

  propagatedBuildInputs = [ typesentry blessed ];
  buildInputs = [ llvm ] ++ lib.optionals stdenv.isDarwin [ openmp ];
  checkInputs = [ pytest ];

  LLVM = llvm;

  checkPhase = ''
    # py.test adds local datatable to path, which doesn't contain built native library.
    mv datatable datatable.hidden
    pytest
  '';

  meta = with lib; {
    description = "data.table for Python";
    homepage = "https://github.com/h2oai/datatable";
    license = licenses.mpl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
