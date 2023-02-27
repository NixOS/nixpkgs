{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, numpy
, scikitimage
, openjpeg
, procps
, pytestCheckHook
, contextlib2
, mock
, importlib-resources
, isPy27
, lxml
}:

buildPythonPackage rec {
  pname = "glymur";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "quintusdias";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xlpax56qg5qqh0s19xidgvv2483sc684zj7rh6zw1m1z9m37drr";
  };

  propagatedBuildInputs = [
    numpy
  ] ++ lib.optionals isPy27 [ contextlib2 mock importlib-resources ];

  nativeCheckInputs = [
    scikitimage
    procps
    pytestCheckHook
    lxml
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


  meta = with lib; {
    description = "Tools for accessing JPEG2000 files";
    homepage = "https://github.com/quintusdias/glymur";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
