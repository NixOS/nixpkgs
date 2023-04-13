{ stdenv, lib, fetchFromGitHub, buildGoModule, fetchpatch }:
buildGoModule rec {
  pname = "starlark";
  version = "unstable-2023-01-12";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "fae38c8a6d89dc410be86b76dfff475b29dba878";
    hash = "sha256-7J2bYA84asWvwSOYEr+K9ZuR2ytR9XhGaSEJKxHimYI=";
  };

  vendorHash = "sha256-AvZh7IqRRAAOG10rLodHLNSuTIQHXPTJkRXsAhZGNe0=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/google/starlark-go";
    description = "An interpreter for Starlark, implemented in Go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
