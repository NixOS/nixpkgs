{ lib
, buildPythonPackage
, fetchFromGitHub
, notebook
, simpervisor
, aiohttp
, pytest
, pytest-asyncio
, isPy27
}:

buildPythonPackage rec {
  pname = "jupyter-server-proxy";
  version = "1.5.3";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "jupyter-server-proxy";
    rev = "v${version}";
    sha256 = "140mlzcnhadxrnhfwf7glx9cgzrcsbs1gmcsks62a8dpdns89spd";
  };

  propagatedBuildInputs = [
    notebook
    simpervisor
    aiohttp
  ];

  checkInputs = [
    pytest
    pytest-asyncio
  ];

  # tests require network
  doCheck = false;

  meta = with lib; {
    description = "Jupyter server extension to supervise and proxy web services";
    homepage = https://github.com/jupyterhub/jupyter-server-proxy;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
