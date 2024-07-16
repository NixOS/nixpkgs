{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  runtimeShell,

  # build
  poetry-core,

  # propagates
  docutils,

  # tests
  pytestCheckHook,
  readme-renderer,
  textile,
}:

buildPythonPackage rec {
  pname = "python-creole";
  version = "1.4.10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jedie";
    repo = "python-creole";
    rev = "refs/tags/v${version}";
    hash = "sha256-8pXOnLNjhIv0d+BqjW8wlb6BT6CmFHSsxn5wLOv3LBQ=";
  };

  patches = [
    # https://github.com/jedie/python-creole/pull/77
    (fetchpatch {
      name = "replace-poetry-with-poetry-core.patch";
      url = "https://github.com/jedie/python-creole/commit/bfc46730ab4a189f3142246cead8d26005a28671.patch";
      hash = "sha256-WtoEQyu/154Cfj6eSnNA+t37+o7Ij328QGMKxwcLg5k=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "/bin/bash" "${runtimeShell}"

    sed -i "/-cov/d" pytest.ini
  '';

  propagatedBuildInputs = [ docutils ];

  pythonImportsCheck = [ "creole" ];

  nativeCheckInputs = [
    pytestCheckHook
    readme-renderer
    textile
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # macro didn't expect argument
    "test_macro_wrong_arguments_quite"
    "test_macro_wrong_arguments_with_error_report"
    # rendering mismatches, likely docutils version mismatch
    "test_headlines1"
    "test_simple_table"
  ];

  disabledTestPaths = [
    # requires poetry
    "creole/tests/test_Makefile.py"
    # requires poetry_publish
    "creole/publish.py"
    "creole/tests/test_project_setup.py"
    # rendering differencenes, likely docutils version mismatch
    "creole/tests/test_cross_compare_rest.py"
    "creole/tests/test_rest2html.py"
  ];

  pytestFlagsArray = [
    # fixture mismatch after docutils update
    "--deselect=creole/rest_tools/clean_writer.py::creole.rest_tools.clean_writer.rest2html"
    "--deselect=creole/tests/test_cross_compare_all.py::CrossCompareTests::test_link"
    "--deselect=creole/tests/test_cross_compare_all.py::CrossCompareTests::test_link_with_at_sign"
    "--deselect=creole/tests/test_cross_compare_all.py::CrossCompareTests::test_link_with_unknown_protocol"
    "--deselect=creole/tests/test_cross_compare_all.py::CrossCompareTests::test_link_without_title"
  ];

  meta = with lib; {
    description = "Creole markup tools written in Python";
    homepage = "https://github.com/jedie/python-creole";
    changelog = "https://github.com/jedie/python-creole/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
