{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "nickel";
  version = "0.1.0";

  src  = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "refs/tags/${version}"; # because pure ${version} doesn't work
    hash = "sha256-St8oK9vP2cAhsNindkebtAMeRPwYggP9E4CciSZc7oA=";
  };

  cargoSha256 = "sha256-VsyK/api8acIpADpXQ8RdbRLiZwHFSDH0vwQrZQ8zp4=";

  meta = with lib; {
    homepage = "https://nickel-lang.org/";
    description = "Better configuration for less";
    longDescription = ''
      Nickel is the cheap configuration language.

      Its purpose is to automate the generation of static configuration files -
      think JSON, YAML, XML, or your favorite data representation language -
      that are then fed to another system. It is designed to have a simple,
      well-understood core: it is in essence JSON with functions.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
