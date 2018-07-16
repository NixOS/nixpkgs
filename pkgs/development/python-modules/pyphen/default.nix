{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "Pyphen";
  version = "0.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mqb5jrigxipxzp1d8nbwkq0cfjw77pnn6hc4mp1yd2mn059mymb";
  };

  meta = with stdenv.lib; {
    description = "Pure Python module to hyphenate text";
    homepage = "https://github.com/Kozea/Pyphen";
    license = with licenses; [gpl2 lgpl21 mpl20];
    maintainers = with maintainers; [ rvl ];
  };
}
