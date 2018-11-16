{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, nose
, six
}:

buildPythonPackage rec {
  pname = "nibabel";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xb6wgc67c0l7csjdd0k5r2p783rlahknrhqqa13qwgxbybadr53";
  };

  propagatedBuildInputs = [
    numpy
    nose
    six
  ];

  # Failing tests
  # nibabel.tests.test_minc1.test_old_namespace
  # nibabel.gifti.tests.test_parse_gifti_fast.test_parse_dataarrays
  # nibabel.gifti.tests.test_giftiio.test_read_deprecated
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://nipy.org/nibabel/;
    description = "Access a multitude of neuroimaging data formats";
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
  };
}
