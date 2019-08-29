{ stdenv
, buildPythonPackage
, fetchPypi
, coverage
, nose
}:

buildPythonPackage rec {
  pname = "nosexcover";
  version = "1.0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "298c3c655da587f6cab8a666e9f4b150320032431062dea91353988d45c8b883";
  };

  propagatedBuildInputs = [ coverage nose ];

  meta = with stdenv.lib; {
    description = "Extends nose.plugins.cover to add Cobertura-style XML reports";
    homepage = https://github.com/cmheisel/nose-xcover/;
    license = licenses.bsd3;
  };

}
