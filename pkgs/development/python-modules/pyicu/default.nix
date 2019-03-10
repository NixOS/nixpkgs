{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, six
, fetchpatch
, pkgs
}:

buildPythonPackage rec {
  pname = "PyICU";
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pzss3l0b0vcsyr7wlqdd6pkcqldspajfgd9k2iijf6r152d2ln4";
  };

  patches = [
    (fetchpatch {
      url = https://sources.debian.org/data/main/p/pyicu/2.0.3-1/debian/patches/icu_test.patch;
      sha256 = "1iavdkyqixm9i753svl17barla93b7jzgkw09dn3hnggamx7zwx9";
    })
  ];

  buildInputs = [ pkgs.icu pytest ];
  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/PyICU/;
    description = "Python extension wrapping the ICU C++ API";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.rycee ];
  };

}
