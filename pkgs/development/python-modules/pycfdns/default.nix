{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pycfdns";
  version = "2.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-f6kxYX/dg16OWYpw29dH4Z26ncLZCYyHKGc4fzoCld0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'version="master",' 'version="${version}",'
  '';

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pycfdns"
  ];

  meta = with lib; {
    description = "Python module for updating Cloudflare DNS A records";
    homepage = "https://github.com/ludeeus/pycfdns";
    changelog = "https://github.com/ludeeus/pycfdns/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
