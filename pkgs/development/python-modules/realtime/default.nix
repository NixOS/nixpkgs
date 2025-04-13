{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, python-dateutil
, typing-extensions
, websockets
, aiohttp
}:

buildPythonPackage rec {
  pname = "realtime";
  version = "2.5.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ROgkB91/z2p3PK75uvkRh8QZ1lOf8AFPAcpLyJoOXFI=";
  };

  propagatedBuildInputs = [
    python-dateutil
    typing-extensions
    websockets
    aiohttp
  ];

  pythonRelaxDeps = [
    "websockets"
    "aiohttp"
    "typing-extensions"
  ];

  pythonImportsCheck = [ "realtime" ];

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace-quiet 'websockets = ">=11,<15"' 'websockets = "*"' 
  '';

  nativeBuildInputs = [ poetry-core ];

  # tests aren't in the pypi package
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/supabase/realtime-py.git";
    license = licenses.mit;
    description = "Python Realtime Client for Supabase";
    maintainers = with maintainers; [ siegema ];
  };
}
