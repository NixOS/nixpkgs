{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, numpy
, scikitimage
, openjpeg
, procps
, pytestCheckHook
, importlib-resources
, pythonOlder
, lxml
}:

buildPythonPackage rec {
  pname = "glymur";
  version = "0.9.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "quintusdias";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ObczavqhBv4NzEd+ggzTAxGx92uxp6ABxLg8bEpXl/Y=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    lxml
    procps
    pytestCheckHook
    scikitimage
  ];

  postConfigure = ''
    substituteInPlace glymur/config.py \
    --replace "path = read_config_file(libname)" "path = '${openjpeg}/lib/lib' + libname + ${if stdenv.isDarwin then "'.dylib'" else "'.so'"}"
  '';

  disabledTestPaths = [
    # this test involves glymur's different ways of finding the openjpeg path on
    # fsh systems by reading an .rc file and such, and is obviated by the patch
    # in postConfigure
    "tests/test_config.py"
  ];

  pythonImportsCheck = [
    "glymur"
  ];

  meta = with lib; {
    description = "Tools for accessing JPEG2000 files";
    homepage = "https://github.com/quintusdias/glymur";
    changelog = "https://github.com/quintusdias/glymur/blob/v${version}/CHANGES.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
