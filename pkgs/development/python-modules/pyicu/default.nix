{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, six
, fetchpatch
, icu
}:

buildPythonPackage rec {
  pname = "PyICU";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ddb2b453853b4c25db382bc5e8c4cde09b3f4696ef1e1494f8294e174f459cf4";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/python-team/modules/pyicu/raw/debian/2.2-2/"
            + "debian/patches/icu_test.patch";
      sha256 = "1iavdkyqixm9i753svl17barla93b7jzgkw09dn3hnggamx7zwx9";
    })
  ];

  nativeBuildInputs = [ icu ]; # for icu-config
  buildInputs = [ icu ];
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    homepage = "https://pypi.python.org/pypi/PyICU/";
    description = "Python extension wrapping the ICU C++ API";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.rycee ];
  };

}
