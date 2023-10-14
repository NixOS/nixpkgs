{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch, isPy311
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "3.0.1";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7IsnamtgvYDe/tJa3X5DmIHBnmSFCv2bNGKD1BZf0P0=";
  };

  patches = lib.optional isPy311 # could be made unconditional on rebuild
    (fetchpatch {
      name = "tests-py311.patch";
      url = "https://github.com/PyCQA/pyflakes/commit/836631f2f73d45baa4021453d89fc9fd6f52be58.diff";
      hash = "sha256-xlgql+bN0HsGnTMkwax3ZG/5wrbkUl/kQkjlr3lsgRw=";
    })
  ;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyflakes" ];

  meta = with lib; {
    homepage = "https://github.com/PyCQA/pyflakes";
    changelog = "https://github.com/PyCQA/pyflakes/blob/${version}/NEWS.rst";
    description = "A simple program which checks Python source files for errors";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
