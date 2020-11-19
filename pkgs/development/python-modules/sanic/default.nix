{ lib
, buildPythonPackage
, fetchPypi
, httptools
, aiofiles
, websockets
, multidict
, uvloop
, ujson
, pytest
, gunicorn
, aiohttp
, beautifulsoup4
, pytest-sanic
, pytest-benchmark

# required just httpcore / requests-async
, h11
, h2
, certifi
, chardet
, idna
, requests
, rfc3986
, uvicorn
}:

let

  # This version of sanic depends on two packages that have been deprecated by
  # their development teams:
  #
  # - requests-async [where first line of pypi says to use `http3` instead now]
  # - httpcore       [where the homepage redirects to `http3` now]
  #
  # Since no other packages in nixpkg depend on these right now, define these
  # packages just as local dependencies here, to avoid bloat.

  httpcore = buildPythonPackage rec {
    pname = "httpcore";
    version = "0.3.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0n3bamaixxhcm27gf1ws3g6rkamvqx87087c88r6hyyl52si1ycn";
    };

    propagatedBuildInputs = [ certifi chardet h11 h2 idna rfc3986 ];

    # relax pinned old version of h11
    postConfigure = ''
      substituteInPlace setup.py \
        --replace "h11==0.8.*" "h11"
      '';

    # LICENCE.md gets propagated without this, causing collisions
    postInstall = ''
      rm $out/LICENSE.md
    '';
  };

  requests-async = buildPythonPackage rec {
    pname = "requests-async";
    version = "0.5.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "8731420451383196ecf2fd96082bfc8ae5103ada90aba185888499d7784dde6f";
    };

    propagatedBuildInputs = [ requests httpcore ];

    # LICENCE.md gets propagated without this, causing collisions
    postInstall = ''
      rm $out/LICENSE.md
    '';
  };

in

buildPythonPackage rec {
  pname = "sanic";
  version = "19.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b1qqsvdjkibrw5kgr0pm7n7jzb1403132wjmb0lx3k5wyvqfi95";
  };

  propagatedBuildInputs = [
    httptools
    aiofiles
    websockets
    multidict
    requests-async
    uvloop
    ujson
  ];

  checkInputs = [
    pytest
    gunicorn
    aiohttp
    beautifulsoup4
    pytest-sanic
    pytest-benchmark
    uvicorn
  ];

  # Sanic says it needs websockets 7.x, but the changelog for 8.x is actually
  # nearly compatible with sanic's use. So relax this constraint, with a small
  # required code change.
  postConfigure = ''
    substituteInPlace setup.py --replace \
      "websockets>=7.0,<8.0"             \
      "websockets>=7.0,<9.0"
    substituteInPlace sanic/websocket.py --replace    \
           "self.websocket.subprotocol = subprotocol" \
           "self.websocket.subprotocol = subprotocol
            self.websocket.is_client = False"
  '';

  # 10/500 tests ignored due to missing directory and
  # requiring network access
  checkPhase = ''
    pytest --ignore tests/test_blueprints.py \
           --ignore tests/test_routes.py \
           --ignore tests/test_worker.py
  '';

  meta = with lib; {
    description = "A microframework based on uvloop, httptools, and learnings of flask";
    homepage = "http://github.com/channelcat/sanic/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
