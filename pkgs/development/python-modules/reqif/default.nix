{ lib
, buildPythonPackage
, python
, pythonOlder
, fetchFromGitHub
, poetry-core
, beautifulsoup4
, lxml
, jinja2
, dataclasses
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "reqif";
  version = "0.0.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = pname;
    rev = version;
    sha256 = "sha256-PtzRJUvv+Oee08+sdakFviKIhwfLngyal1WSWDtMELg=";
  };

  postPatch = ''
    substituteInPlace ./tests/unit/conftest.py --replace \
       "os.path.abspath(os.path.join(__file__, \"../../../../reqif\"))" \
      "\"${placeholder "out"}/${python.sitePackages}/reqif\""
    substituteInPlace pyproject.toml --replace "^" ">="
    substituteInPlace requirements.txt --replace "==" ">="
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    lxml
    jinja2
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ];

  pythonImportsCheck = [
    "reqif"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python library for ReqIF format";
    homepage = "https://github.com/strictdoc-project/reqif";
    license = licenses.asl20;
    maintainers = with maintainers; [ yuu ];
  };
}
