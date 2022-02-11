{ lib, buildPythonPackage, fetchPypi, dmidecode }:

buildPythonPackage rec {
  pname = "py-dmidecode";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bv1vmhj8h520kj6slwpz16xfmgp117yjjkfyihkl5ix6mn5zkpa";
  };

  propagatedBuildInputs = [ dmidecode ];

  # Project has no tests.
  doCheck = false;
  pythonImportsCheck = [ "dmidecode" ];

  meta = with lib; {
    homepage = "https://github.com/zaibon/py-dmidecode/";
    description = "Python library that parses the output of dmidecode";
    license = licenses.asl20;
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.linux;
  };
}
