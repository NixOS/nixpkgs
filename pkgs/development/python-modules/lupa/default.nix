{ lib
, buildPythonPackage
, fetchPypi
, lua
, pkgconfig
}:

buildPythonPackage rec {
  pname = "lupa";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xvfh27rv7ili9xc5nfg2nnnlj9iyxxcjinkcs71xz1spxp3zmyj";
  };

  buildInputs = [ lua pkgconfig ];

  meta = with lib; {
    description = "Integrates the runtime of Lua or LuaJIT2 into CPython";
    homepage = https://github.com/scoder/lupa;
    license = licenses.mit;
    maintainers = with maintainers; [ ivan ];
  };
}
