{ lib, fetchurl, tcl }:

tcl.mkTclDerivation {
  pname = "wapp";
  version = "unstable-2024-04-14";

  src = fetchurl {
    url = "https://wapp.tcl-lang.org/home/raw/3dfe5da86ad053c5";
    hash = "sha256-zw/UGiQXfs6wCQhP696bRDiq/xAHhq4Rvp5JkAmoe+I=";
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
    description = "A framework for writing web applications in Tcl";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nat-418 ];
  };
}
