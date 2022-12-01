{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, pythonOlder
, rich
, typer
}:

buildPythonPackage rec {
  pname = "rich-click";
  version = "1.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ewels";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eW5CR7ReVsFLJ09F4EUQbvFB+GdlnTay0bX4NNLQ0xo=";
  };

  propagatedBuildInputs = [
    click
    rich
  ];

  passthru.optional-dependencies = {
    typer = [
      typer
    ];
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "typer>=0.4,<0.6" "typer>=0.4"
  '';

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [
    "rich_click"
  ];

  meta = with lib; {
    description = "Module to format click help output nicely with rich";
    homepage = "https://github.com/ewels/rich-click";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
