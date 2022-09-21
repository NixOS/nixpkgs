{ lib
, buildPythonPackage
, fetchFromGitHub
, docutils
, mock
, pygments
, twine
, pytestCheckHook
}:

let python-decouple = buildPythonPackage rec {
  pname = "python-decouple";
  version = "3.6";

  src = fetchFromGitHub {
    owner = "henriquebastos";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ll0MZb4FaNFF/jvCfj4TkuoAi4m448KaOU3ykvKPbSo=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "==" ">="
  '';

  propagatedBuildInputs = [
    docutils
    mock
    pygments
    twine
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "decouple"
  ];

  doCheck = false;

  passthru.tests = {
    default = python-decouple.overridePythonAttrs (oldAttrs: {
      doCheck = true;
    });
  };

  meta = with lib; {
    description = "Strict separation of config from code";
    homepage = "https://github.com/henriquebastos/python-decouple";
    license = licenses.mit;
    maintainers = with maintainers; [
      yuu
    ];
  };
}; in python-decouple
