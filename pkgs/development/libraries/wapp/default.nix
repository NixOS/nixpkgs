{ lib, fetchurl, tcl }:

tcl.mkTclDerivation {
  pname = "wapp";
  version = "0-unstable-2024-05-23";

  src = fetchurl {
    url = "https://wapp.tcl-lang.org/home/raw/98f23b2160bafc41f34be8e5d8ec414c53d33412eb2f724a07f2476eaf04ac6f?at=wapp.tcl";
    hash = "sha256-A+Ml5h5C+OMoDQtAoB9lHgYEK1A7qHExT3p46PHRTYg=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/wapp
    cp $src $out/lib/wapp/wapp.tcl
    cat <<EOF > $out/lib/wapp/pkgIndex.tcl
    package ifneeded wapp 1.0 [list source [file join \$dir wapp.tcl]]
    EOF

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://wapp.tcl-lang.org/home/doc/trunk/README.md";
    description = "Framework for writing web applications in Tcl";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nat-418 ];
  };
}
