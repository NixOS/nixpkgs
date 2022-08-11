{ lib
, fetchFromGitHub
, buildPythonPackage
, sniffio
, pytestCheckHook
, starlette
, trio
}:

buildPythonPackage rec {
  pname = "asgi-lifespan";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "florimondmanca";
    repo = "asgi-lifespan";
    rev = version;
    sha256 = "sha256-QooFNxtGQYCRuITvlz3Mkd61XOwnKj6ctBzl1lJkRYE=";
  };

  postPatch = ''
    # Remove coverage tests
    sed -i '21,24d' setup.cfg
  '';

  propagatedBuildInputs = [
    sniffio
  ];

  checkInputs = [
    pytestCheckHook
    starlette
    trio
  ];

  pythonImportsCheck = [ "asgi_lifespan" ];

  meta = with lib; {
    description = "Programmatic startup/shutdown of ASGI apps";
    homepage = "https://github.com/florimondmanca/asgi-lifespan";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
