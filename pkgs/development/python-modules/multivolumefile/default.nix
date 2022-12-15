{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "multivolumefile";
  version = "0.2.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oGSNCq+8luWRmNXBfprK1+tTGr6lEDXQjOgGDcrXCdY=";
  };

  doCheck = false;
  propagatedBuildInputs = [
    setuptools-scm
  ];

  meta = with lib; {
    homepage = "https://github.com/miurahr/multivolume";
    description = "library to provide a file-object wrapping multiple files as virtually like as a single file";
    license = licenses.lgpl21Plus;
  };
}
