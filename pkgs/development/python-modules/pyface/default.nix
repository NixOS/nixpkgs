{ stdenv, fetchPypi, buildPythonPackage
, setuptools, six, traits, wxPython
}:

buildPythonPackage rec {
  pname = "pyface";
  version = "6.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q5rihmhcdyyp44p31f5l4a0mc9m3293rvcnma5p8w0v8j7dbrm7";
  };

  propagatedBuildInputs = [ setuptools six traits wxPython ];

  doCheck = false; # Needs X server

  meta = with stdenv.lib; {
    description = "Traits-capable windowing framework";
    homepage = https://github.com/enthought/pyface;
    maintainers = with stdenv.lib.maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
