{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, portalocker
, torch
, tqdm
}:

buildPythonPackage rec {
  pname = "iopath";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "iopath";
    rev = "v${version}";
    hash = "sha256-Qubf/mWKMgYz9IVoptMZrwy4lQKsNGgdqpJB1j/u5s8=";
  };

  # A few tests do HTTP. One could disable them individually
  doCheck = false;

  propagatedBuildInputs = [
    tqdm
    portalocker
    torch
  ];

  meta = with lib; {
    description = "A python library that provides common I/O interface across different storage backends";
    homepage = "https://github.com/facebookresearch/iopath";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
