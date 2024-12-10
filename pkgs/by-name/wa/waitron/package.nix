{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "waitron";
  version = "unstable-2020-08-04";
  rev = "2315857d94e3d1a1e79ac48f8f6a68d59d0ce300";

  src = fetchFromGitHub {
    owner = "ns1";
    repo = "waitron";
    inherit rev;
    sha256 = "sha256-ZkGhEOckIOYGb6Yjr4I4e9cjAHDfksRwHW+zgOMZ/FE=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  patches = [
    ./staticfiles-directory.patch
  ];

  meta = with lib; {
    description = "Tool to manage network booting of machines";
    longDescription = ''
      Waitron is used to build machines (primarily bare-metal, but anything that
      understands PXE booting will work) based on definitions from any number of
      specified inventory sources.
    '';
    homepage = "https://github.com/ns1/waitron";
    license = licenses.asl20;
    maintainers = with maintainers; [ guibert ];
    platforms = platforms.linux;
    broken = true; # vendor isn't reproducible with go > 1.17: nix-build -A $name.goModules --check
  };
}
