{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, nose
}:

buildPythonPackage rec {
  pname = "rope";
  version = "0.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "786b5c38c530d4846aa68a42604f61b4e69a493390e3ca11b88df0fbfdc3ed04";
  };

  patches = [
    # Python 3.9 ast changes
    (fetchpatch {
      url = "https://github.com/python-rope/rope/pull/333.patch";
      excludes = [ ".github/workflows/main.yml" ];
      sha256 = "1gq7n1zs18ndmv0p8jg1h5pawabi1m9m9z2w5hgidvqmpmcziky0";
    })
  ];

  checkInputs = [
    nose
  ];

  checkPhase = ''
    # tracked upstream here https://github.com/python-rope/rope/issues/247
    NOSE_IGNORE_FILES=type_hinting_test.py nosetests ropetest
  '';

  meta = with lib; {
    description = "Python refactoring library";
    homepage = "https://github.com/python-rope/rope";
    changelog = "https://github.com/python-rope/rope/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ goibhniu ];
  };
}
