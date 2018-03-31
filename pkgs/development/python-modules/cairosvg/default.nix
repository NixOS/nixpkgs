{ stdenv, buildPythonPackage, fetchPypi, cairocffi }:

buildPythonPackage rec {
  pname = "cairosvg";
  version = "1.0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01lpm38qp7xlnv8jv7qg48j44p5088dwfsrcllgs5fz355lrfds1";
  };

  propagatedBuildInputs = [ cairocffi ];

  meta = with stdenv.lib; {
    homepage = https://cairosvg.org;
    license = licenses.lgpl3;
    description = "SVG converter based on Cairo";
  };
}
