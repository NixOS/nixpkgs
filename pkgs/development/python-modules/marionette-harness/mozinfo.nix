{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, mozfile
}:

buildPythonPackage rec {
  pname = "mozinfo";
  version = "0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dcd53a1b1793340418e1ae42bf300e3e56d8f12047972378c6f9318b220b1023";
  };

  disabled = isPy3k;

  propagatedBuildInputs = [ mozfile ];

  meta = with stdenv.lib; {
    description = "System information utilities for Mozilla testing";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = licenses.mpl20;
    maintainers = with maintainers; [ raskin ];
  };
}
