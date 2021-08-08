{ stdenv, lib, buildPythonPackage, fetchPypi, substituteAll, pythonOlder
, pipInstallHook, writeText
, blessed
, docutils
, libcxx
, llvm
, pytestCheckHook
, typesentry
}:

buildPythonPackage rec {
  pname = "datatable";
  version = "0.11.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19c602711e00f72e9ae296d8fa742d46da037c2d3a2d254bdf68f817a8da76bb";
  };
  # authors seem to have created their own build system
  format = "other";

  # tarball doesn't appear to have been shipped totally ready-to-build
  postPatch = ''
    substituteInPlace ci/ext.py \
      --replace \
        'shell_cmd(["git"' \
        '"0000000000000000000000000000000000000000" or shell_cmd(["git"'
    echo '${version}' > VERSION.txt
  '';
  DT_RELEASE = "1";

  buildPhase = ''
    python ci/ext.py wheel
  '';

  propagatedBuildInputs = [ typesentry blessed ];
  buildInputs = [ llvm pipInstallHook ];
  checkInputs = [ docutils pytestCheckHook ];

  LLVM = llvm;
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-isystem ${lib.getDev libcxx}/include/c++/v1";

  pytestFlagsArray = let
    # ini file (not included in tarball) required to change python_files setting,
    pytestIni = writeText "pytest.ini" ''
      [pytest]
      python_files = test_*.py test-*.py
    '';
  in [
    "-c ${pytestIni}"
  ];
  disabledTests = [
    # skip tests which are irrelevant to our installation or use way too much memory
    "test_xfunction_paths"
    "test_fread_from_cmd2"
    "test_cast_huge_to_str"
    "test_create_large_string_column"
  ];
  pythonImportsCheck = [ "datatable" ];

  meta = with lib; {
    description = "data.table for Python";
    homepage = "https://github.com/h2oai/datatable";
    license = licenses.mpl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
