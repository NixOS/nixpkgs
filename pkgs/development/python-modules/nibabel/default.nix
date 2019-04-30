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
  version = "2.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6366634c65b04464e62f3a9a8df1faa172f780ed7f1af1c6818b3dc2f1202c3";
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
