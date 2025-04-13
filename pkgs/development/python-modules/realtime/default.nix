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
  version = "2.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jndhbYxyHw8X6golb2tc1tYmsOtmswVUTV8zDDptmkw=";
  };

  propagatedBuildInputs = [
    python-dateutil
    typing-extensions
    websockets
    aiohttp
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
