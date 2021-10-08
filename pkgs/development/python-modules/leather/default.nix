{ lib, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname = "leather";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b43e21c8fa46b2679de8449f4d953c06418666dc058ce41055ee8a8d3bb40918";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    homepage = "http://leather.rtfd.io";
    description = "Python charting library";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ vrthra ];
  };
}
