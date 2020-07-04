{ stdenv, fetchPypi, buildPythonPackage
, setuptools, six, traits
}:

buildPythonPackage rec {
  pname = "pyface";
  version = "7.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e00aba15de9c0e553dfcc7b346c3541c54f35054dd05b72a9e2343e340adf6f";
  };

  propagatedBuildInputs = [ setuptools six traits ];

  doCheck = false; # Needs X server

  meta = with stdenv.lib; {
    description = "Traits-capable windowing framework";
    homepage = "https://github.com/enthought/pyface";
    maintainers = with stdenv.lib.maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
