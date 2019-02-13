{ stdenv
, buildPythonPackage
, fetchurl
, isPyPy
, isPy3k
}:

buildPythonPackage rec {
  version = "0.4.10";
  pname = "mmpython";

  src = fetchurl {
    url = https://sourceforge.net/projects/mmpython/files/latest/download;
    sha256 = "1b7qfad3shgakj37gcj1b9h78j1hxlz6wp9k7h76pb4sq4bfyihy";
    name = "${pname}-${version}.tar.gz";
  };

  disabled = isPyPy || isPy3k;

  meta = with stdenv.lib; {
    description = "Media Meta Data retrieval framework";
    homepage = https://sourceforge.net/projects/mmpython/;
    license = licenses.gpl2;
  };

}
