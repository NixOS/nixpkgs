{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname   = "prjxray-tools";
  version = "0.1-2676-gac8d30e3";

  src = fetchFromGitHub {
    owner  = "SymbiFlow";
    repo   = "prjxray";
    fetchSubmodules = true;
    rev    = "ac8d30e3fe2029122408888d2313844b3e0c265b";
    sha256 = "1ag7dk12hdhip821crwinncp8vgyzs0r85l1h2vbgn61lnxc7f4h";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Documenting the Xilinx 7-series bit-stream format";
    homepage    = "https://github.com/SymbiFlow/prjxray";
    license     = licenses.isc;
    platforms   = platforms.all;
    maintainers = with maintainers; [ mcaju ];
  };
}
