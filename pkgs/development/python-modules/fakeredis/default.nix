{ lib
, aioredis
, async_generator
, buildPythonPackage
, fetchPypi
, fetchpatch
, hypothesis
, lupa
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, redis
, six
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "fakeredis";
  version = "1.7.0";

  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yb0S5DAzbL0+GJ+uDpHrmZl7k+dtv91u1n+jUtxoTHE=";
  };

  patches = [
    (fetchpatch {
      # redis 4.1.0 compatibility
      # https://github.com/jamesls/fakeredis/pull/324
      url = "https://github.com/jamesls/fakeredis/commit/8ef8dc6dacc9baf571d66a25ffbf0fadd7c70f78.patch";
      sha256 = "sha256:03xlqmwq8nkzisrjk7y51j2jd6qdin8nbj5n9hc4wjabbvlgx4qr";
      excludes = [
        "setup.cfg"
      ];
    })
  ];

  propagatedBuildInputs = [
    aioredis
    lupa
    redis
    six
    sortedcontainers
  ];

  checkInputs = [
    async_generator
    hypothesis
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fakeredis"
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "redis<4.1.0" "redis"
  '';

  meta = with lib; {
    description = "Fake implementation of Redis API";
    homepage = "https://github.com/jamesls/fakeredis";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
