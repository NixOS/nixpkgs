{ lib
, buildPythonPackage
, fetchurl
, glibcLocales
}:

buildPythonPackage rec {
  pname = "rpmfluff";
  version = "0.5.7.1";
  format = "setuptools";

  src = fetchurl {
  url = "https://releases.pagure.org/${pname}/${pname}-${version}.tar.xz";
    sha256 = "19vnlzma8b0aghdiixk0q3wc10y6306hsnic0qvswaaiki94fss1";
  };

  LC_ALL="en_US.utf-8";
  buildInputs = [ glibcLocales ];

  meta = with lib; {
    description = "lightweight way of building RPMs, and sabotaging them";
    homepage = "https://pagure.io/rpmfluff";
    license = licenses.gpl2;
    maintainers = with maintainers; [ disassembler ];
  };

}
