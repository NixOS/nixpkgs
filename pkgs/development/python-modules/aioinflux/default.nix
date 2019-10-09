{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytz
, aiohttp
, ciso8601
, pandas
, numpy
}:

buildPythonPackage rec {
  pname = "aioinflux";
  version = "0.9.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "gusutabopb";
    repo = "aioinflux";
    rev = "v${version}";
    sha256 = "0cvzkd05i8bzh76m75s7na2gb0kh5msyyz60ajxpj2by9x6qkxmc";
  };

  propagatedBuildInputs = [ aiohttp pytz ciso8601 pandas ];

  # Tests require local networking so won't run in the sandbox
  doCheck = false;

  meta = with lib; {
    description = "Asynchronous Python client for InfluxDB";
    homepage = https://github.com/gusutabopb/aioinflux;
    license = licenses.mit;
    maintainers = with maintainers; [ liamdiprose ];
  };
}
