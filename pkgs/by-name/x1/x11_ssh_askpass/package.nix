{
  lib,
  stdenv,
  fetchurl,
  fetchDebianPatch,
  autoreconfHook,
  pkg-config,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "x11-ssh-askpass";
  version = "1.2.4.1";

  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    url = "http://pkgs.fedoraproject.org/repo/pkgs/openssh/x11-ssh-askpass-${version}.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-${version}.tar.gz";
    sha256 = "620de3c32ae72185a2c9aeaec03af24242b9621964e38eb625afb6cdb30b8c88";
  };

  patches = [
    (fetchDebianPatch {
      pname = "ssh-askpass";
      version = "1:1.2.4.1";
      debianRevision = "16";
      patch = "autotools.patch";
      hash = "sha256-S2tl0GeDia/ZuyXetPOsiu79kS9yLId7gUj3siw7pH4=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    xorg.libX11
    xorg.libXt
    xorg.libICE
    xorg.libSM
  ];

  meta = with lib; {
    homepage = "https://github.com/sigmavirus24/x11-ssh-askpass";
    description = "Lightweight passphrase dialog for OpenSSH or other open variants of SSH";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
