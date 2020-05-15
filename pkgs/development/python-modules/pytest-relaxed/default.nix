{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, six
, decorator
}:

buildPythonPackage rec {
  version = "1.1.5";
  pname = "pytest-relaxed";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e39a7e5b14e14dfff0de0ad720dfffa740c128d599ab14cfac13f4deb34164a6";
  };

  buildInputs = [ pytest ];
  checkInputs = [ pytest ];

  propagatedBuildInputs = [ six decorator ];

  patchPhase = ''
    sed -i "s/pytest>=3,<5/pytest/g" setup.py
  '';

  # skip tests due to dir requirements
  doCheck = false;

  checkPhase = ''
    pytest tests
  '';

  meta = with stdenv.lib; {
    homepage = "https://pytest-relaxed.readthedocs.io/";
    description = "Relaxed test discovery/organization for pytest";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };
}
