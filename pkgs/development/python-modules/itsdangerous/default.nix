{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "itsdangerous";
  version = "0.24";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06856q6x675ly542ig0plbqcyab6ksfzijlyf1hzhgg3sgwgrcyb";
  };

  meta = with stdenv.lib; {
    description = "Helpers to pass trusted data to untrusted environments and back";
    homepage = "https://pypi.python.org/pypi/itsdangerous/";
    license = licenses.bsd0;
  };

}
