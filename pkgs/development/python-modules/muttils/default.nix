{ stdenv
, buildPythonPackage
, fetchurl
, isPy3k
}:

buildPythonPackage {
  pname = "muttils";
  version = "1.3";
  disabled = isPy3k;

  src = fetchurl {
    url = https://www.blacktrash.org/hg/muttils/archive/8bb26094df06.tar.bz2;
    sha256 = "1a4kxa0fpgg6rdj5p4kggfn8xpniqh8v5kbiaqc6wids02m7kag6";
  };

  # Tests don't work
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Utilities for use with console mail clients, like mutt";
    homepage = https://www.blacktrash.org/hg/muttils;
    license = licenses.gpl2Plus;
  };

}
