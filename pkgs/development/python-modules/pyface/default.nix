{ stdenv, fetchPypi, buildPythonPackage
, setuptools, six, traits
}:

buildPythonPackage rec {
  pname = "pyface";
  version = "7.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43943cc15889153b90191d9e1bd85e7a3709a6d57b6379220cb14017217fb999";
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
