{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pyexcel-io,
  xlrd,
  xlwt,
  pyexcel,
  pytestCheckHook,
  pytest-cov,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyexcel-xls";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyexcel";
    repo = "pyexcel-xls";
    rev = "v${version}";
    hash = "sha256-wxsx/LfeBxi+NnHxfxk3svzsBcdwOiLQ1660eoHfmLg=";
  };

  patches = [
    # https://github.com/pyexcel/pyexcel-xls/pull/54
    (fetchpatch2 {
      name = "nose-to-pytest.patch";
      url = "https://github.com/pyexcel/pyexcel-xls/compare/d8953c8ff7dc9a4a3465f2cfc182acafa49f6ea2...9f0d48035114f73077dd0f109395af32b4d9d48b.patch";
      hash = "sha256-2kVdN+kEYaJjXGzv9eudfKjRweMG0grTd5wnZXIDzUU=";
      excludes = [ ".github/*" ];
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    pyexcel-io
    xlrd
    xlwt
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyexcel
    pytest-cov
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "xlrd<2" "xlrd<3"
  '';

  meta = {
    description = "Wrapper library to read, manipulate and write data in xls using xlrd and xlwt";
    homepage = "http://docs.pyexcel.org/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
