{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "robotframework";
  version = "3.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f10dd7c0c8c7962a4f80dd1e026b5db731b9391bc6e1f9ebb96d685eb1230dbc";
    extension = "zip";
  };

  meta = with stdenv.lib; {
    description = "Generic test automation framework";
    homepage = https://robotframework.org/;
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
  };
}
