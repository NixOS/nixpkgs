{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, nose
, six
}:

buildPythonPackage rec {
  pname = "nibabel";
  version = "2.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6366634c65b04464e62f3a9a8df1faa172f780ed7f1af1c6818b3dc2f1202c3";
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
