{ lib
, buildPythonPackage
, fetchPypi
, cython
, setuptools-scm
, wheel
, fonttools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "compreffor";
  version = "0.5.4";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MGulQEUGPrQ30T3VYzwRRlvzvWkFqNzqsNzAjtjX9xU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"setuptools_git_ls_files",' ""

    substituteInPlace setup.py \
      --replace '"setuptools_git_ls_files"' ""
  '';

  nativeBuildInputs = [
    cython
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    fonttools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Tests cannot seem to open the cpython module.
  doCheck = false;

  pythonImportsCheck = [
    "compreffor"
  ];

  meta = with lib; {
    description = "CFF table subroutinizer for FontTools";
    homepage = "https://github.com/googlefonts/compreffor";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
