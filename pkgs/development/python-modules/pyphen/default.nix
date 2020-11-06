{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "Pyphen";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "719b21dfb4b04fbc11cc0f6112418535fe35474021120cccfffc43a25fe63128";
  };

  meta = with stdenv.lib; {
    description = "Pure Python module to hyphenate text";
    homepage = "https://github.com/Kozea/Pyphen";
    license = with licenses; [gpl2 lgpl21 mpl20];
    maintainers = with maintainers; [ rvl ];
  };
}
