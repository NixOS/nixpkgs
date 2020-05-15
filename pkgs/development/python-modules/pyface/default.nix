{ stdenv, fetchPypi, buildPythonPackage
, setuptools, six, traits
}:

buildPythonPackage rec {
  pname = "pyface";
  version = "6.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1g2g3za64rfffbivlihbf5njrqbv63ln62rv9d8fi1gcrgaw6akw";
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
