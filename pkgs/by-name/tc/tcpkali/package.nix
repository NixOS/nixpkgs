{lib, stdenv, autoreconfHook, fetchFromGitHub, bison}:

let version = "1.1.1"; in

stdenv.mkDerivation rec {
  pname = "tcpkali";
  inherit version;
  src = fetchFromGitHub {
    owner = "machinezone";
    repo = "tcpkali";
    rev = "v${version}";
    sha256 = "09ky3cccaphcqc6nhfs00pps99lasmzc2pf5vk0gi8hlqbbhilxf";
  };
  postPatch = ''
    sed -ie '/sys\/sysctl\.h/d' src/tcpkali_syslimits.c
  '';
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ bison];
  meta = {
    description = "High performance TCP and WebSocket load generator and sink";
    license = lib.licenses.bsd2;
    inherit (src.meta) homepage;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ethercrow ];
    mainProgram = "tcpkali";
  };
}
