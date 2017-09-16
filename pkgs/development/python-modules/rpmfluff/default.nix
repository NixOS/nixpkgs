{ stdenv, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  pname = "rpmfluff";
  version = "0.5.3";
  name  = "${pname}-${version}";

  src = fetchurl {
    url = "https://releases.pagure.org/${pname}/${name}.tar.xz";
    sha256 = "1i45f012ngpxs83m3dpmaj3hs8z7r9sbf05vnvzgs3hpgsbhxa7r";
  };

  meta = with stdenv.lib; {
    description = "lightweight way of building RPMs, and sabotaging them";
    homepage = https://pagure.io/rpmfluff;
    license = licenses.gpl2;
    maintainers = with maintainers; [ disassembler ];
  };

}
