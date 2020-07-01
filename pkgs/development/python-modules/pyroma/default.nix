{ stdenv, buildPythonPackage, fetchPypi
, docutils, pygments, setuptools
}:

buildPythonPackage rec {
  pname = "pyroma";
  version = "2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00j1j81kiipi5yppmk385cbfccf2ih0xyapl7pw6nqhrf8vh1764";
  };

  propagatedBuildInputs = [ docutils pygments setuptools ];

  meta = with stdenv.lib; {
    description = "Test your project's packaging friendliness";
    homepage = "https://github.com/regebro/pyroma";
    license = licenses.mit;
  };
}
