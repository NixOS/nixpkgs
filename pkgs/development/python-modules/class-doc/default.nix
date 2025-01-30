{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  more-itertools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "class-doc";
  version = "0.2.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "danields761";
    repo = pname;
    rev = "9b122d85ce667d096ebee75a49350bbdbd48686d"; # no 0.2.6 version tag
    hash = "sha256-4Sn/TuBvBpl1nvJBg327+sVrjGavkYKEYP32DwLWako=";
  };

  patches = [
    # https://github.com/danields761/class-doc/pull/2
    (fetchpatch {
      name = "poetry-to-poetry-core.patch";
      url = "https://github.com/danields761/class-doc/commit/03b224ad0a6190c30e4932fa2ccd4a7f0c5c4b5d.patch";
      hash = "sha256-shWPRaZkvtJ1Ae17aCOm6eLs905jxwq84SWOrChEs7M=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ more-itertools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "class_doc" ];

  meta = with lib; {
    description = "Extract attributes docstrings defined in various ways";
    homepage = "https://github.com/danields761/class-doc";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
