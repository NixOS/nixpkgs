{ lib
, buildPythonPackage
, fetchFromGitHub
, head ? false
}: let
  version-info = if head then {
    version = "0.9pre20221026";
    rev = "e9f802c7b37a23efa3e6411364a5333c9c956258";
    sha256 = "sha256-s0d0rTK5sZVE6H/cESvc/IXenDdM2oZvdlx6k5fA5W8=";
  } else rec {
    version = "0.8.3";
    rev = "v${version}";
    sha256 = "0nhm7j2y4rgmrl0c1rklg982qllp7fky34dchqwd4czbsdnv9j7a";
  };
in buildPythonPackage {
  pname = "hetzner";
  inherit (version-info) version;
  format = "setuptools";

  src = fetchFromGitHub {
    inherit (version-info) rev sha256;
    repo = "hetzner";
    owner = "aszlig";
  };

  meta = with lib; {
    homepage = "https://github.com/RedMoonStudios/hetzner";
    description = "High-level Python API for accessing the Hetzner robot";
    mainProgram = "hetznerctl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aszlig ];
  };
}
