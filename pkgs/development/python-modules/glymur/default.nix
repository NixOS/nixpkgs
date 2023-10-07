{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, lxml
, numpy
, openjpeg
, pytestCheckHook
, pythonOlder
, scikit-image
, setuptools
}:

buildPythonPackage rec {
  pname = "glymur";
  version = "0.12.5";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "quintusdias";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9NMSAt5yFRnlCUDP37/ozhDsS8FTdRkfjUz8kQwWzVc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    lxml
    pytestCheckHook
    scikit-image
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
    "tests/test_tiff2jp2.py"
  ];

  pythonImportsCheck = [
    "glymur"
  ];

  meta = with lib; {
    description = "Tools for accessing JPEG2000 files";
    homepage = "https://github.com/quintusdias/glymur";
    changelog = "https://github.com/quintusdias/glymur/blob/v${version}/CHANGES.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
