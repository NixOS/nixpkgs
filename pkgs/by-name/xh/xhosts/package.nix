{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "nss-xhosts";
  version = "unstable-2023-12-30";

  src = fetchFromGitHub {
    owner = "dvob";
    repo = "nss-xhosts";
    rev = "78658cc24abb2546936f2b298a27d4abdf629186";
    hash = "sha256-saK9CxN4Ek1QBlPOydzEFei1217gPe5MZrUaUHh80hI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  postFixup = "mv $out/lib/*.so $out/lib/libnss_xhosts.so.2";

  meta = with lib; {
    description = "NSS Module which supports wildcards";
    homepage = "https://github.com/dvob/nss-xhosts";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "nss-xhosts";
  };
}
