{
  lib,
  buildPackages,
  callPackage,
}:

let
  src = buildPackages.fetchgit {
    url = "https://gitlab.redox-os.org/redox-os/relibc/";
    rev = "02e4d980200cb5d7a3b61b1d968e9821c0ecbc31";
    hash = "sha256-//Bmz9kwPt4TTkXiU9ZLcUckoqkaeHCbgdA7IjPIEaM=";
    fetchSubmodules = true;
  };

in
callPackage ./relibc.nix {
  inherit src;
  meta = with lib; {
    homepage = "https://gitlab.redox-os.org/redox-os/relibc";
    description = "C Library in Rust for Redox and Linux";
    license = licenses.mit;
    maintainers = [ maintainers.anderscs ];
    platforms = platforms.redox ++ [ "x86_64-linux" ];
  };
}
