{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, boost
, libusb1
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "cc-tool";
  version = "unstable-2020-05-19";

  src = fetchFromGitHub {
    owner = "dashesy";
    repo = pname;
    rev = "19e707eafaaddee8b996ad27a9f3e1aafcb900d2";
    hash = "sha256:1f78j498fdd36xbci57jkgh25gq14g3b6xmp76imdpar0jkpyljv";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ boost libusb1 ];

  postPatch = ''
    substituteInPlace udev/90-cc-debugger.rules \
      --replace 'MODE="0666"' 'MODE="0660", GROUP="plugdev", TAG+="uaccess"'
  '';

  postInstall = ''
    install -D udev/90-cc-debugger.rules $out/lib/udev/rules.d/90-cc-debugger.rules
  '';

  meta = with lib; {
    description = "Command line tool for the Texas Instruments CC Debugger";
    mainProgram = "cc-tool";
    longDescription = ''
      cc-tool provides support for Texas Instruments CC Debugger
    '';
    homepage = "https://github.com/dashesy/cc-tool";
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.CRTified ];
  };
}
