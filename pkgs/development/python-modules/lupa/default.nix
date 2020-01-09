{ lib
, buildPythonPackage
, fetchFromGitHub
, luajit
, cython
, pkg-config
}:

buildPythonPackage rec {
  pname = "lupa";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "scoder";
    repo = pname;
    rev = "lupa-${version}";
    sha256 = "1k9q2lfw3gacmz1p15xpr3paxrsf69xjmdf4lhv7m0p67j16pmyc";
  };

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  buildInputs = [
    luajit
  ];

  meta = with lib; {
    description = "Python wrapper around Lua and LuaJIT";
    homepage = https://github.com/scoder/lupa;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
