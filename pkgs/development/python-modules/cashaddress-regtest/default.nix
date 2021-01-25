{ lib, stdenv, fetchFromGitHub, buildPythonPackage, pytestCheckHook }:

buildPythonPackage rec {
  pname = "cashaddress-regtest";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nicolaiskye";
    repo = "cashaddress-regtest";
    rev = version;
    sha256 = "1z4iq60n685z5bfksl8lvcqawhxh8dz8rqqf933cq3mj8zk98jpz";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Tool for converting bitcoin cash legacy addresses";
    homepage = "https://github.com/nicolaiskye/cashaddress-regtest";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = lib.platforms.unix;
  };
}
