{
  lib,
  fetchFromGitHub,
  tcl,
  tcllib,
}:

tcl.mkTclDerivation rec {
  pname = "mustache-tcl";
  version = "1.1.3.4";

  src = fetchFromGitHub {
    owner = "ianka";
    repo = "mustache.tcl";
    rev = "v${version}";
    sha256 = "sha256-apM57LEZ0Y9hXcEPWrKYOoTVtP5QSqiaQrjTHQc3pc4=";
  };

  buildInputs = [
    tcllib
  ];

  unpackPhase = ''
    mkdir -p $out/lib/mustache-tcl
    cp $src/mustache.tcl $out/lib/mustache-tcl/mustache.tcl
    cp $src/pkgIndex.tcl $out/lib/mustache-tcl/pkgIndex.tcl
  '';

  meta = with lib; {
    homepage = "https://github.com/ianka/mustache.tcl";
    description = "Tcl implementation of the mustache templating language";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ nat-418 ];
  };
}
