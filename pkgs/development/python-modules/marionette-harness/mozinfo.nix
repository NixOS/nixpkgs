{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, mozfile
}:

buildPythonPackage rec {
  pname = "mozinfo";
  version = "0.9";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jwhnhbj7xipwh33wf7m12pw5g662dpr1chkp6p2fmy0mwpn2y4z";
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
