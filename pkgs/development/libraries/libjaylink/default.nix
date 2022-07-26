{ fetchFromGitLab, lib, stdenv
, autoreconfHook, pkg-config
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "libjaylink";
  version = "0.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.zapb.de";
    owner = "libjaylink";
    repo = "libjaylink";
    rev = version;
    sha256 = "0ndyfh51hiqyv2yscpj6qd091w7myxxjid3a6rx8f6k233vy826q";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libusb1 ];

  postPatch = ''
    patchShebangs autogen.sh
  '';

  postInstall = ''
    install -Dm644 contrib/99-libjaylink.rules $out/lib/udev/rules.d/libjaylink.rules
  '';

  meta = with lib; {
    homepage = "https://gitlab.zapb.de/libjaylink/libjaylink";
    description = "libjaylink is a shared library written in C to access SEGGER J-Link and compatible devices.";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.linux;
  };
}
