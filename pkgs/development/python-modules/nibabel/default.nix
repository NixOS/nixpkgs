{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, numpy
, six
, bz2file
, nose
, mock
}:

buildPythonPackage rec {
  pname = "nibabel";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f165ff1cb4464902d6594eb2694e2cfb6f8b9fe233b856c976c3cff623ee0e17";
  };

  propagatedBuildInputs = [
    numpy
    six
  ] ++ lib.optional (!isPy3k) bz2file;

  checkInputs = [ nose mock ];

  checkPhase = let
    excludeTests = lib.optionals isPy3k [
      # https://github.com/nipy/nibabel/issues/691
      "nibabel.gifti.tests.test_giftiio.test_read_deprecated"
      "nibabel.gifti.tests.test_parse_gifti_fast.test_parse_dataarrays"
      "nibabel.tests.test_minc1.test_old_namespace"
    ];
  # TODO: Add --with-doctest once all doctests pass
  in ''
    nosetests ${lib.concatMapStrings (test: "-e '${test}' ") excludeTests}
  '';

  meta = with lib; {
    homepage = https://nipy.org/nibabel/;
    description = "Access a multitude of neuroimaging data formats";
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
  };
}
