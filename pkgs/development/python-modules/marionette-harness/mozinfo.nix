{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, mozfile
}:

buildPythonPackage rec {
  pname = "mozinfo";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "50c0ec524b21260749a103db8e8405716e4027b580a18cea1574d2424789bbe2";
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
