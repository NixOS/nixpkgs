{ lib
, buildPythonPackage
, fetchFromGitHub
, asynctest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aionotify";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "rbarrois";
    repo = "aionotify";
    rev = "v${version}";
    sha256 = "1sk9i8czxgsbrswsf1nlb4c82vgnlzi8zrvrxdip92w2z8hqh43y";
  };

  disabled = pythonOlder "3.5";

  preCheck = ''
    substituteInPlace tests/test_usage.py \
      --replace "asyncio.wait_for(task, timeout, loop=self.loop)" "asyncio.wait_for(task, timeout)"
  '';

  checkInputs = [
    asynctest
  ];

  meta = with lib; {
    homepage = "https://github.com/rbarrois/aionotify";
    description = "Simple, asyncio-based inotify library for Python";
    license = with lib.licenses; [ bsd2 ];
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
