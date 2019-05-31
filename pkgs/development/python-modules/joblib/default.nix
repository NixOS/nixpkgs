{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, sphinx
, numpydoc
, pytest
, python-lz4
}:


buildPythonPackage rec {
  pname = "joblib";
  version = "0.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "315d6b19643ec4afd4c41c671f9f2d65ea9d787da093487a81ead7b0bac94524";
  };

  # python-lz4 compatibility
  # https://github.com/joblib/joblib/pull/847
  patches = [
    (fetchpatch {
      url = https://github.com/joblib/joblib/commit/d3235fd601f40c91e074d48a411d7380329fe155.patch;
      sha256 = "1hg1vfbba7mfilrpvmd97s68v03vs4bhlp1c1dj9lizi51mj2q2h";
    })
    (fetchpatch {
      url = https://github.com/joblib/joblib/commit/884c92cd2aa5c2c1975ab48786da75556d779833.patch;
      sha256 = "11kvpkvi428dq13ayy7vfyrib8isvcrdw8cd5hxkp5axr7sl12ba";
    })
    (fetchpatch {
      url = https://github.com/joblib/joblib/commit/f1e177d781cc0d64420ec964a0b17d8268cb42a0.patch;
      sha256 = "1sq6wcw4bhaq8cqwcd43fdws3467qy342xx3pgv62hp2nn75a21d";
    })
  ];

  checkInputs = [ sphinx numpydoc pytest ];
  propagatedBuildInputs = [ python-lz4 ];

  # test_disk_used is broken
  # https://github.com/joblib/joblib/issues/57
  checkPhase = ''
    py.test joblib -k "not test_disk_used"
  '';

  meta = {
    description = "Lightweight pipelining: using Python functions as pipeline jobs";
    homepage = https://pythonhosted.org/joblib/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
