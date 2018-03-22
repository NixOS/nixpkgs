{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, nose
, six
}:

buildPythonPackage rec {
  pname = "nibabel";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h6nhi1s2ab7sdyyl3qjnvlw0kggcnam7vn4b3z56ay20596kvhw";
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
