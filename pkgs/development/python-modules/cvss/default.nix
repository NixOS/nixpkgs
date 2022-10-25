{ buildPythonPackage
, fetchPypi
, jsonschema
, lib
}:

buildPythonPackage rec {
  pname = "cvss";
  version = "2.5";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-Y/ZIz/smR0mM8oZGpwBP4PSIcsm6fYZTvr1xBAn4ug4=";
  };

  propagatedBuildInputs = [
    jsonschema
  ];

  meta = with lib; {
    description = "CVSS2/3 library with interactive calculator for Python 2 and Python 3";
    homepage = "https://github.com/skontar/cvss";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.raboof ];
    platforms = platforms.all;
  };
}
