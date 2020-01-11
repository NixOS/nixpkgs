{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, isPy27
, mock
, nose
, numpy
, pytest
, six
}:

buildPythonPackage rec {
  pname = "nibabel";
  version = "3.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f5bc325c9cb203c6f0ab876ba1a5ada811284bb3a4c5d063eeaafaefbad873d";
  };

  propagatedBuildInputs = [
    numpy
    six
  ];

  checkInputs = [ nose mock pytest ];

  checkPhase = ''
    nosetests -e "test_fallback_version"
  '';
  # `test_fallback_version` temporarily disabled due to https://github.com/nipy/nibabel/issues/855

  meta = with lib; {
    homepage = https://nipy.org/nibabel/;
    description = "Access a multitude of neuroimaging data formats";
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
    platforms = platforms.x86_64;  # some tests fail for unclear reasons on aarch64
  };
}
