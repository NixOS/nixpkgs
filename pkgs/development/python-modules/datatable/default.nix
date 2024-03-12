{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pipInstallHook
, writeText
, blessed
, docutils
, libcxx
, llvm
, pytestCheckHook
, typesentry
}:

buildPythonPackage rec {
  pname = "datatable";
  # python 3.10+ support is not in the 1.0.0 release
  version = "unstable-2022-12-15";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "h2oai";
    repo = pname;
    rev = "9522f0833d3e965656396de4fffebd882d39c25d";
    hash = "sha256-lEXQwhx2msnJkkRrTkAwYttlYTISyH/Z7dSalqRrOhI=";
  };

  postPatch = ''
    # tarball doesn't appear to have been shipped totally ready-to-build
    substituteInPlace ci/ext.py \
      --replace \
        'shell_cmd(["git"' \
        '"0000000000000000000000000000000000000000" or shell_cmd(["git"'
    # TODO revert back to use ${version} when bumping to the next stable release
    echo '1.0' > VERSION.txt

    # don't make assumptions about architecture
    sed -i '/-m64/d' ci/ext.py
  '';
  DT_RELEASE = "1";

  propagatedBuildInputs = [ typesentry blessed ];
  buildInputs = [ llvm pipInstallHook ];
  nativeCheckInputs = [ docutils pytestCheckHook ];

  LLVM = llvm;
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-isystem ${lib.getDev libcxx}/include/c++/v1";

  # test suite is very cpu intensive, only run small subset to ensure package is working as expected
  pytestFlagsArray = [ "tests/test-sets.py" ];

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
