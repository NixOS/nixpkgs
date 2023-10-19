{ lib
, buildPythonPackage
, cython
, fetchpatch
, fetchPypi
, setuptools-scm
, fonttools
, pytestCheckHook
, wheel
}:

buildPythonPackage rec {
  pname = "compreffor";
  version = "0.5.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MGulQEUGPrQ30T3VYzwRRlvzvWkFqNzqsNzAjtjX9xU=";
  };

  patches = [
    # https://github.com/googlefonts/compreffor/pull/153
    (fetchpatch {
      name = "remove-setuptools-git-ls-files.patch";
      url = "https://github.com/googlefonts/compreffor/commit/10f563564390568febb3ed1d0f293371cbd86953.patch";
      hash = "sha256-wNQMJFJXTFILGzAgzUXzz/rnK67/RU+exYP6MhEQAkA=";
    })
  ];

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
