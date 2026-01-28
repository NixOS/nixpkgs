{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  httpx,
  pycognito,
}:
buildPythonPackage rec {
  name = "myenergi";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "CJNE";
    repo = "pymyenergi";
    rev = "${version}";
    sha256 = "sha256-nWeaL54a0Eu4Rv6zhNcCA++ypMQfrUdYLuOAMSUq9H0=";
  };

  doCheck = false;

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  pyproject = true;
  build-system = [ setuptools ];

  propagatedBuildInputs = [
    httpx
    pycognito
  ];

  meta = {
    homepage = "https://github.com/rjpearce/myenergi-python";
    description = "Implementation of the API used by the MyEnergi application";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ benediktbroich ];
  };
}
