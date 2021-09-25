{ lib, fetchpatch, buildPythonPackage, fetchPypi
, aiohttp, pytest, pytest-cov, pytest-aiohttp
}:

buildPythonPackage rec {
  pname = "aiohttp_remotes";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vv2ancxsaxlls9sinigjnrqyx95n7cphq37m8nwifkhvs0idv6a";
  };

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [ pytest pytest-cov pytest-aiohttp ];
  checkPhase = ''
    python -m pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/wikibusiness/aiohttp-remotes";
    description = "A set of useful tools for aiohttp.web server";
    license = licenses.mit;
    maintainers = [ maintainers.qyliss ];
  };
}
