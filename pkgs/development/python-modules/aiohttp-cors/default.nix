{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, typing ? null, aiohttp
}:

buildPythonPackage rec {
  pname = "aiohttp-cors";
  version = "0.7.0";

  src = fetchFromGitHub {
     owner = "aio-libs";
     repo = "aiohttp-cors";
     rev = "v0.7.0";
     sha256 = "1zmh6c76r4qrn9wsndqcd7j9xnnd8g8glazl63gnkrfhqrsx51sd";
  };

  disabled = pythonOlder "3.5";

  propagatedBuildInputs = [ aiohttp ]
  ++ lib.optional (pythonOlder "3.5") typing;

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "CORS support for aiohttp";
    homepage = "https://github.com/aio-libs/aiohttp-cors";
    license = licenses.asl20;
    maintainers = with maintainers; [ primeos ];
  };
}
