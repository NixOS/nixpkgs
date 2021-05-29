{ lib, buildPythonPackage, fetchFromGitHub
, aiohttp, irc, pyyaml, pytestCheckHook
}:

buildPythonPackage {
  pname = "heisenbridge";
  version = "unstable-2021-05-23";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = "heisenbridge";
    rev = "1f8df49b7e89aaeb2cbb5fee68bd29cf3eda079a";
    sha256 = "sha256-ta6n9hXRdIjfxsLy9jrzZkz6TS50/TYpFOb/BLrRWK4=";
  };

  propagatedBuildInputs = [
    aiohttp
    irc
    pyyaml
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A bouncer-style Matrix-IRC bridge.";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
  };
}
