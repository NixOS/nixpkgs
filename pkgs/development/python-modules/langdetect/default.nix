{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "langdetect";
  version = "1.0.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0c5zm6c7xzsigbb9c7v4r33fcpz911zscfwvh3dq1qxdy3ap18ci";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Python port of Google's language-detection library";
    homepage = https://github.com/Mimino666/langdetect;
    license = licenses.asl20;
    maintainers = with maintainers; [ earvstedt ];
  };
}
