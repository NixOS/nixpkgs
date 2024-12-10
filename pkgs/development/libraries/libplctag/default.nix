{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "libplctag";
  version = "2.5.5";

  src = fetchFromGitHub {
    owner = "libplctag";
    repo = "libplctag";
    rev = "v${version}";
    sha256 = "sha256-eWtQaYUWZNQYQOUXnbUfjrtpoO6CnNJ8WjlowA49sG0=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/libplctag/libplctag";
    description = "Library that uses EtherNet/IP or Modbus TCP to read and write tags in PLCs";
    license = with licenses; [
      lgpl2Plus
      mpl20
    ];
    maintainers = with maintainers; [ petterstorvik ];
    platforms = platforms.all;
  };
}
