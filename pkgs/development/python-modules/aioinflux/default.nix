{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, ciso8601
, pandas
}:

buildPythonPackage rec {
  pname = "aioinflux";
  version = "0.9.0";

  src = fetchFromGitHub {
     owner = "gusutabopb";
     repo = "aioinflux";
     rev = "v0.9.0";
     sha256 = "0cvzkd05i8bzh76m75s7na2gb0kh5msyyz60ajxpj2by9x6qkxmc";
  };

  propagatedBuildInputs = [ aiohttp ciso8601 pandas ];

  # Tests require InfluxDB server
  doCheck = false;

  pythonImportsCheck = [ "aioinflux" ];

  meta = with lib; {
    description = "Asynchronous Python client for InfluxDB";
    homepage = "https://github.com/gusutabopb/aioinflux";
    license = licenses.mit;
    maintainers = with maintainers; [ liamdiprose lopsided98 ];
  };
}
