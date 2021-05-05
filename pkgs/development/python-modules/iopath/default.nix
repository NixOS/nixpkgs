{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, portalocker
, pytorch
, tqdm
}:

buildPythonPackage rec {
  pname = "iopath";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "iopath";
    rev = "v${version}";
    sha256 = "1v79z6rja4q21na31mzs6ff63as8k6gpssi2d0wpikgzk84xva0l";
  };

  # A few tests do HTTP. One could disable them individually
  doCheck = false;

  propagatedBuildInputs = [
    tqdm
    portalocker
    pytorch
  ];

  meta = with lib; {
    description = "A python library that provides common I/O interface across different storage backends";
    homepage = "https://github.com/facebookresearch/iopath";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
