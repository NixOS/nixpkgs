{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
, Mako
, markdown
, setuptools-git
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pdoc3";
  version = "0.10.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5f22e7bcb969006738e1aa4219c75a32f34c2d62d46dc9d2fb2d3e0b0287e4b7";
  };

  patches = [
    (fetchpatch {
      # test_Class_params fails in 0.10.0
      # https://github.com/pdoc3/pdoc/issues/355
      url = "https://github.com/pdoc3/pdoc/commit/4aa70de2221a34a3003a7e5f52a9b91965f0e359.patch";
      sha256 = "07sbf7bh09vgd5z1lbay604rz7rhg88414whs6iy60wwbvkz5c2v";
    })
  ];

  nativeBuildInputs = [
    setuptools-git
    setuptools-scm
  ];

  propagatedBuildInputs = [
    Mako
    markdown
  ];

  pytestFlagsArray = [
    "--pyargs" "test"
  ];

  disabledTests = [
    # AssertionError: assert len(warnings.filters) == orig_filter_len - 2
    "test_unload"
    "test_unlink"
    "test_temp_dir__path_none"
    "test_temp_dir__forked_child"
    # AssertionError: self.assertEqual(len(messages), 0, messages)
    "test_ignored_deprecations_are_silent"
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Auto-generate API documentation for Python projects.";
    homepage = "https://pdoc3.github.io/pdoc/";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ catern ];
  };
}
