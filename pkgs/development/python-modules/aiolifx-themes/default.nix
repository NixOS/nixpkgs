{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, aiolifx
, poetry-core
, pytest-asyncio
, pytestCheckHook
, async-timeout
, typer
}:

buildPythonPackage rec {
  pname = "aiolifx-themes";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Djelibeybi";
    repo = "aiolifx-themes";
    rev = "v${version}";
    hash = "sha256:17498vdg8i20hk4i8hzc67qaj206ik3s1zn1k70plsjr9zlgs6vz";
  };

  prePatch = ''
    # Don't run coverage, or depend on typer for no reason.
    substituteInPlace pyproject.toml \
      --replace " --cov=aiolifx_themes --cov-report=term-missing:skip-covered" "" \
      --replace "typer = " "# unused: typer = "
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiolifx
  ];

  checkInputs = [
    async-timeout
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "aiolifx_themes"
  ];

  meta = with lib; {
    description = "Color themes for LIFX lights running on aiolifx";
    homepage = "https://github.com/Djelibeybi/aiolifx-themes";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
  };
}
