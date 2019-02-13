{ stdenv
, buildPythonPackage
, fetchurl
, glibcLocales
}:

buildPythonPackage rec {
  pname = "rpmfluff";
  version = "0.5.6";

  src = fetchurl {
  url = "https://releases.pagure.org/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0bhh8mv2kddhv3fiswg3zdl91d7vh93b33jlh1dmyz63z94rm88l";
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
