{ lib, nimPackages, fetchFromGitHub, raylib }:

nimPackages.buildNimPackage rec {
  pname = "nimraylib-now";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "greenfork";
    repo = "nimraylib_now";
    rev = "v${version}";
    sha256 = "sha256-18YiAzJ46dpD5JN+gH0MWKchZ5YLPBNcm9eVFnyy2Sw=";
  };

  propagatedBuildInputs = [ raylib ];

  doCheck = false; # no $DISPLAY available

  meta = with lib; {
    homepage = "https://github.com/greenfork/nimraylib_now";
    description = "The Ultimate Raylib gaming library wrapper for Nim";
    license = licenses.mit;
    maintainers = with maintainers; [ annaaurora ];
  };
}
