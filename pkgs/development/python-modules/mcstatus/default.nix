{ lib
, asyncio-dgram
, buildPythonPackage
, click
, dnspython
, fetchFromGitHub
, mock
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "mcstatus";
  version = "8.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Dinnerbone";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-19VO5L5abVGm5zEMt88o67ArLjBCnGO2DxfAD+u1hF4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    asyncio-dgram
    click
    dnspython
    six
  ];

  checkInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'asyncio-dgram = "1.2.0"' 'asyncio-dgram = ">=1.2.0"' \
      --replace 'dnspython = "2.1.0"' 'dnspython = "^2.1.0"' \
      --replace 'six = "1.14.0"' 'six = ">=1.14.0"' \
      --replace 'click = "7.1.2"' 'click = ">=7.1.2"'
  '';

  pythonImportsCheck = [
    "mcstatus"
  ];

  meta = with lib; {
    description = "Python library for checking the status of Minecraft servers";
    homepage = "https://github.com/Dinnerbone/mcstatus";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
