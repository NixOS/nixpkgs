{
  lib,
  stdenv,
  fetchurl,
  cmake,
  readline,
}:

stdenv.mkDerivation rec {
  pname = "tasksh";
  version = "1.2.0";

  src = fetchurl {
    url = "https://taskwarrior.org/download/${pname}-${version}.tar.gz";
    sha256 = "1z8zw8lld62fjafjvy248dncjk0i4fwygw0ahzjdvyyppx4zjhkf";
  };

  buildInputs = [ readline ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "REPL for taskwarrior";
    homepage = "http://tasktools.org";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.unix;
    mainProgram = "tasksh";
  };
}
