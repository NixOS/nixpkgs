{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "nickel";
  version = "0.3.1";

  src  = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "refs/tags/${version}"; # because pure ${version} doesn't work
    hash = "sha256-bUUQP7ze0j8d+VEckexDOferAgAHdKZbdKR3q0TNOeE=";
  };

  cargoSha256 = "sha256-E8eIUASjCIVsZhptbU41VfK8bFmA4FTT3LVagLrgUso=";

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
    changelog = "https://github.com/tweag/nickel/blob/${version}/RELEASES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
