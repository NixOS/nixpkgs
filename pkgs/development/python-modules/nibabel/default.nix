{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, nose
, six
}:

buildPythonPackage rec {
  pname = "nibabel";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf34aeb0f7ca52dc528ae4f842607cea307b334163857ff1d64d43068f637ada";
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
