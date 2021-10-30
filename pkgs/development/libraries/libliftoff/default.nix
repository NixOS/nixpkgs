{ lib, stdenv, fetchFromGitHub
, meson, pkg-config, ninja
, libdrm
}:

stdenv.mkDerivation rec {
  pname = "libliftoff";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s53jsll3c7272bhmh4jr6k5m1nvn8i1ld704qmzsm852ilmgrla";
  };

  nativeBuildInputs = [ meson pkg-config ninja ];

  buildInputs = [ libdrm ];

  meta = with lib; {
    description = "A lightweight KMS plane library";
    longDescription = ''
      libliftoff eases the use of KMS planes from userspace without standing in
      your way. Users create "virtual planes" called layers, set KMS properties
      on them, and libliftoff will pick planes for these layers if possible.
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/emersion/libliftoff/releases/tag/v${version}";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
