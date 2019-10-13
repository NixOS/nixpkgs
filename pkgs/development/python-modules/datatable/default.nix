{ stdenv, lib, buildPythonPackage, fetchPypi, substituteAll, pythonOlder
, blessed
, docutils
, libcxx
, libcxxabi
, llvm
, openmp
, pytest
, typesentry
}:

buildPythonPackage rec {
  pname = "datatable";
  version = "0.9.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1shwjkm9nyaj6asn57vwdd74pn13pggh14r6dzv729lzxm7nm65f";
  };

  patches = lib.optionals stdenv.isDarwin [
    # Replace the library auto-detection with hardcoded paths.
    (substituteAll {
      src = ./hardcode-library-paths.patch;

      libomp_dylib = "${lib.getLib openmp}/lib/libomp.dylib";
      libcxx_dylib = "${lib.getLib libcxx}/lib/libc++.1.dylib";
      libcxxabi_dylib = "${lib.getLib libcxxabi}/lib/libc++abi.dylib";
    })
  ];

  propagatedBuildInputs = [ typesentry blessed ];
  buildInputs = [ llvm ] ++ lib.optionals stdenv.isDarwin [ openmp ];
  checkInputs = [ docutils pytest ];

  LLVM = llvm;

  checkPhase = ''
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
