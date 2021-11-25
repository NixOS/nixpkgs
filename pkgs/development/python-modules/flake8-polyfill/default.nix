{ lib, fetchPypi, buildPythonPackage
, flake8, fetchpatch
, mock, pep8, pytest }:

buildPythonPackage rec {
  pname = "flake8-polyfill";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nlf1mkqw856vi6782qcglqhaacb23khk9wkcgn55npnjxshhjz4";
  };

  patches = [
    # allow newer flake8 versions
    # update when there is a version upgrade to flake8.
    (fetchpatch {
      url = "https://github.com/PyCQA/flake8-polyfill/pull/14/commits/649ee70574e5f64c09ada38da38dab6761c34549.patch";
      sha256 = "sha256-WhASXEyVFQwDWq/sOclE9SQzrT5TDLk/s5yg326slKM=";
      name = "fix-version.patch";
    })
  ];

  postPatch = ''
    # Failed: [pytest] section in setup.cfg files is no longer supported, change to [tool:pytest] instead.
    substituteInPlace setup.cfg \
      --replace pytest 'tool:pytest'
  '';

  propagatedBuildInputs = [
    flake8
  ];

  checkInputs = [
    mock
    pep8
    pytest
  ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/pycqa/flake8-polyfill";
    description = "Polyfill package for Flake8 plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
