{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
}:

buildPythonPackage rec {
  pname = "aiodocker";
  # unstable includes support for python 3.10+
  version = "unstable-2022-01-20";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "f1dbdc3d42147f4c2ab5e6802acf6f7d0f885be4";
    sha256 = "RL5Ck4wsBZO88afmoojeFKbdIeCjDo/SwNqUcERH6Ls=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # tests require docker daemon
  doCheck = false;
  pythonImportsCheck = [ "aiodocker" ];

  meta = with lib; {
    description = "Docker API client for asyncio";
    homepage = "https://github.com/aio-libs/aiodocker";
    license = licenses.asl20;
    maintainers = with maintainers; [ emilytrau ];
  };
}
