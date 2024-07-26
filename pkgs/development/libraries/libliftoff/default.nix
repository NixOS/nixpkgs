{ lib, stdenv, fetchFromGitLab
, meson, pkg-config, ninja
, libdrm
}:

stdenv.mkDerivation rec {
  pname = "libliftoff";
  version = "0.4.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NPwhsd6IOQ0XxNQQNdaaM4kmwoLftokV86WYhoa5csY=";
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
    maintainers = with maintainers; [ primeos Scrumplex ];
  };
}
