{ stdenv, fetchPypi, buildPythonPackage
, setuptools, six, traits
}:

buildPythonPackage rec {
  pname = "pyface";
  version = "7.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a3e22a4d31429f0d5b9ff50aaac3fb47e4f7da678b6b0439a7b91ef40675f88d";
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
