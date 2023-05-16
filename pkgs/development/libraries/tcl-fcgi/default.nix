{ lib, fetchFromGitHub, tcl, tclx }:

tcl.mkTclDerivation rec {
  pname = "tcl-fcgi";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mpcjanssen";
    repo = "tcl-fcgi";
    rev = "HEAD";
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
    homepage = "https://github.com/${src.owner}/${src.repo}";
    description = "Tcl interface for the FastCGI protocol";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ nat-418 ];
  };
}

