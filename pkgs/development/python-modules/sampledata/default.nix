{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
  pytz,
  six,
  versiontools,
}:

buildPythonPackage rec {
  pname = "sampledata";
  version = "0.3.7";
  format = "setuptools";

  meta = {
    description = "Sample Data generator for Python ";
    homepage = "https://github.com/jespino/sampledata";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kx2j49lag30d32zhzsr50gl5b949wa4lcdap2filg0d07picsdh";
  };

  buildInputs = [
    nose
    versiontools
  ];
  propagatedBuildInputs = [
    pytz
    six
  ];

  # ERROR: test_image_path_from_directory (tests.tests.TestImageHelpers)
  # ERROR: test_image_stream (tests.tests.TestImageHelpers)
  doCheck = false;

  checkPhase = ''
    nosetests -e "TestImageHelpers"
  '';
}
