{ stdenv, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname = "leather";
  version = "0.3.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "125r372q7bwcajfdysp7w5zh5wccwxf1mkhqawl8h518nl1icv87";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    homepage = http://leather.rtfd.io;
    description = "Python charting library";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ vrthra ];
  };
}
