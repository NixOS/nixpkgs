{ lib, fetchpatch, buildPythonPackage, fetchPypi
, aiohttp, pytest, pytestcov, pytest-aiohttp
}:

buildPythonPackage rec {
  pname = "aiohttp_remotes";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43c3f7e1c5ba27f29fb4dbde5d43b900b5b5fc7e37bf7e35e6eaedabaec4a3fc";
  };

  patches = [
    (fetchpatch {
      url = https://github.com/aio-libs/aiohttp-remotes/commit/188772abcea038c31dae7d607e487eeed44391bc.patch;
      sha256 = "0pb1y4jb8ar1szhnjiyj2sdmdk6z9h6c3wrxw59nv9kr3if5igvs";
    })
  ];

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [ pytest pytestcov pytest-aiohttp ];
  checkPhase = ''
    python -m pytest
  '';

  meta = with lib; {
    homepage = https://github.com/wikibusiness/aiohttp-remotes;
    description = "A set of useful tools for aiohttp.web server";
    license = licenses.mit;
    maintainers = [ maintainers.qyliss ];
  };
}
