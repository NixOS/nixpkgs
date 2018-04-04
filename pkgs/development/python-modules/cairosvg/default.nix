{ stdenv, buildPythonPackage, fetchPypi, cairocffi }:

buildPythonPackage rec {
  pname = "cairosvg";
  version = "2.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b334f4ec436d78ecbc934c652f961a73a27d770f1133082cac265afab3dd64a";
  };

  propagatedBuildInputs = [ cairocffi ];

  meta = with stdenv.lib; {
    homepage = https://cairosvg.org;
    license = licenses.lgpl3;
    description = "SVG converter based on Cairo";
  };
}
