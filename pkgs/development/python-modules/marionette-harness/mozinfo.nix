{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, mozfile
}:

buildPythonPackage rec {
  pname = "mozinfo";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4525c26350fb85c26b38c5f853a19f47b17b49a74de363d285d54258972a4cbc";
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
