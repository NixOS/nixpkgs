{ lib, fetchFromGitHub, tcl, tclx }:

tcl.mkTclDerivation rec {
  pname = "tcl-fcgi";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mpcjanssen";
    repo = "tcl-fcgi";
    rev = "62452dbf3177ba9458fbb42457834ca77bdf5a82";
    sha256 = "sha256-RLuV4ARmGWCJTmhs7DbMWENQGj3d5ZXWb821WrgG0qA=";
  };

  buildInputs = [
    tclx
  ];

  unpackPhase = ''
    mkdir -p $out/lib/tcl-fcgi
    cp -r $src/tcl-src/* $out/lib/tcl-fcgi/
  '';

  meta = with lib; {
    homepage = "https://github.com/mpcjanssen/tcl-fcgi";
    description = "Tcl interface for the FastCGI protocol";
    license = licenses.bsd2;
    platforms = tclx.meta.platforms;
    maintainers = with maintainers; [ nat-418 ];
  };
}

