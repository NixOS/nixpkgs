{ lib, fetchurl, tcl }:

tcl.mkTclDerivation {
  pname = "wapp";
  version = "unstable-2023-05-05";

  src = fetchurl {
    url = "https://wapp.tcl-lang.org/home/raw/72d0d081e3e6a4aea91ddf429a85cbdf40f9a32d46cccfe81bb75ee50e6cf9cf?at=wapp.tcldir?ci=9d3368116c59ef16";
    hash = "sha256-poG7dvaiOXMi4oWMQ5t3v7SYEqZLUY/TsWXrTL62xd0=";
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
