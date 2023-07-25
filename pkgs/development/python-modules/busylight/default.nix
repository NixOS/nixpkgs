{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, bitvector-for-humans
, webcolors
, pyserial
, loguru
, typer
, fastapi
, hidapi
, setuptools
, anyio
, trio
, uvicorn
, pytestCheckHook
, requests
, httpx
, pytest-mock
}:

buildPythonPackage rec {
  pname = "busylight";
  version = "0.26.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "JnyJny";
    repo = "busylight";
    rev = "refs/tags/${version}";
    hash = "sha256-nNfDieUdWN+eVAh8+99POsvYawnX3pAOazLIue0p9ao=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace "poetry.masonry" "poetry.core.masonry" \
    --replace 'loguru = "^0.6.0"' 'loguru = ">=0.6,<0.8"' \
    --replace 'hidapi = "^0.13.1"' 'hidapi = "^0.14.0"' \
    --replace 'typer = "^0.7.0"' 'typer = "^0.9.0"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    bitvector-for-humans
    webcolors
    pyserial
    loguru
    typer
    fastapi
    hidapi
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
    httpx
    pytest-mock
  ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d/
    $out/bin/busylight udev-rules -o $out/etc/udev/rules.d/99-busylights.rules
  '';

  pythonImportsCheck = [ "busylight" ];

  passthru.optional-dependencies = {
    webapi = [
      uvicorn
    ];
    development = [
      anyio
      trio
    ];
  };

  meta = {
    homepage = "https://github.com/JnyJny/busylight";
    description = "Control USB connected presence lights from multiple vendors via the command-line or web API";
    changelog = "https://github.com/JnyJny/busylight/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ swflint ];
  };
}
