{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pipInstallHook,
  pythonAtLeast,
  blessed,
  docutils,
  llvm,
  pytestCheckHook,
  typesentry,
}:

buildPythonPackage rec {
  pname = "datatable";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "h2oai";
    repo = "datatable";
    tag = "v${version}";
    hash = "sha256-U6FYqjbVed/Qsxj/8bgwRd2UlK0dq/i61Fg56Br+lzs=";
  };

  postPatch = ''
    # tarball doesn't appear to have been shipped totally ready-to-build
    substituteInPlace ci/ext.py \
      --replace-fail \
        'shell_cmd(["git"' \
        '"0000000000000000000000000000000000000000" or shell_cmd(["git"'
    echo '${version}' > VERSION.txt

    # don't make assumptions about architecture
    substituteInPlace ci/ext.py \
      --replace-fail \
        'ext.compiler.add_linker_flag("-m64")' \
        'pass  # removed -m64 flag assumption'

    # Fix flatbuffers span const member assignment issue
    # Remove const from member variables to allow assignment operator to work
    substituteInPlace src/core/lib/flatbuffers/stl_emulation.h \
      --replace-fail \
        'pointer const data_;' \
        'pointer data_;' \
      --replace-fail \
        'const size_type count_;' \
        'size_type count_;'
  '';
  DT_RELEASE = "1";

  propagatedBuildInputs = [
    typesentry
    blessed
  ];
  buildInputs = [
    llvm
    pipInstallHook
  ];
  nativeCheckInputs = [
    docutils
    pytestCheckHook
  ];

  LLVM = llvm;
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-isystem ${lib.getInclude stdenv.cc.libcxx}/include/c++/v1";

  # test suite is very cpu intensive, only run small subset to ensure package is working as expected
  enabledTestPaths = [ "tests/test-sets.py" ];

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
    maintainers = [ ];
  };
}
