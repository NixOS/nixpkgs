{ lib
, fetchPypi
, buildPythonPackage
, lxml
, docopt
, six
, pytestCheckHook
, mock
, fetchpatch
}:

buildPythonPackage rec {
  pname = "rnginline";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JWqzs+OqOynIAWYVgGrZiuiCqObAgGe6rBt0DcP3U6E=";
  };

  patches = [
    # Fix failing tests. Should be included in releases after 0.0.2
    # https://github.com/h4l/rnginline/issues/3
    (fetchpatch {
      url = "https://github.com/h4l/rnginline/commit/b1d1c8cda2a17d46627309950f2442021749c07e.patch";
      hash = "sha256-XbisEwun2wPOp7eqW2YDVdayJ4sjAMG/ezFwgoCKe9o=";
      name = "fix_tests_failing_collect.patch";
    })
  ];

  propagatedBuildInputs = [
    docopt
    lxml
    six
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rnginline" ];

  meta = with lib; {
    description = "A Python library and command-line tool for loading multi-file RELAX NG schemas from arbitary URLs, and flattening them into a single RELAX NG schema";
    homepage = "https://github.com/h4l/rnginline";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse ];
  };
}
