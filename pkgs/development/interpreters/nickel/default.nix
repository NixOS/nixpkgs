{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "nickel";
  version = "0.2.0";

  src  = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "refs/tags/${version}"; # because pure ${version} doesn't work
    hash = "sha256-Bh83qn+ECZnlCH/A34G5G5MdcAHPow24RMCVQXR5Awg=";
  };

  cargoSha256 = "sha256-vI+SaVyRJjLNqenUsYtaSTyOZRT0zZJ1OZHekcb5LjY=";

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
