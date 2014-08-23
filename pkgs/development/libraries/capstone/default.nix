{ stdenv, fetchurl, bash }:

stdenv.mkDerivation rec {
  name    = "capstone-${version}";
  version = "2.1.2";

  src = fetchurl {
    url    = "http://www.capstone-engine.org/download/${version}/${name}.tgz";
    sha256 = "1k6px3vdcsfby3lakss5sazs875kbzkzqk7cj79xrm2y5ik1vr29";
  };

  buildPhase = false;

  patchPhase = ''
    substituteInPlace make.sh --replace "/usr/bin/env bash" "${bash}/bin/bash"
  '';

  installPhase = "PREFIX=$out ./make.sh install";

  meta = {
    description = "advanced disassembly library";
    homepage    = "http://www.capstone-engine.org";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
