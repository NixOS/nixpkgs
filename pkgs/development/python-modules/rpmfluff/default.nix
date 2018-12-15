{ stdenv
, buildPythonPackage
, fetchurl
, glibcLocales
}:

buildPythonPackage rec {
  pname = "rpmfluff";
  version = "0.5.5";

  src = fetchurl {
  url = "https://releases.pagure.org/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0m92ihii8fgdyma9vn3s6fhq0px8n930c27zs554la0mm4548ss3";
  };

  LC_ALL="en_US.utf-8";
  buildInputs = [ glibcLocales ];

  meta = with stdenv.lib; {
    description = "lightweight way of building RPMs, and sabotaging them";
    homepage = https://pagure.io/rpmfluff;
    license = licenses.gpl2;
    maintainers = with maintainers; [ disassembler ];
  };

}
