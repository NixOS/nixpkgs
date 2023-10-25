{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, more-itertools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "class-doc";
  version = "0.2.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "danields761";
    repo = "${pname}";
    rev = "9b122d85ce667d096ebee75a49350bbdbd48686d"; # no 0.2.6 version tag
    hash = "sha256-4Sn/TuBvBpl1nvJBg327+sVrjGavkYKEYP32DwLWako=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace \
      "poetry.masonry.api" \
      "poetry.core.masonry.api"
  '';

  propagatedBuildInputs = [
    more-itertools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "class_doc"
  ];

  meta = with lib; {
    description = "Extract attributes docstrings defined in various ways";
    homepage = "https://github.com/danields761/class-doc";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
