{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pycfdns";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "0df4695cb0h6f2lnn6dx4h5al2ra93zp1hzfaz07nj2gvirswp83";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pycfdns" ];

  meta = with lib; {
    description = "Python module for updating Cloudflare DNS A records";
    homepage = "https://github.com/ludeeus/pycfdns";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
