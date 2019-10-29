{ buildPythonPackage
, fetchPypi
, lib
, fetchpatch
, sphinx
, flake8
, pytest
, pytestcov
, pytest-flakes
, pytestpep8
}:

buildPythonPackage rec {
  version = "1.5.2";
  pname = "portalocker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17rfgmgwyxyng8q7bvn369cncadqws2wgkg45q6v8337wm9jxins";
  };

  checkInputs = [
    sphinx
    flake8
    pytest
    pytestcov
    pytest-flakes
    pytestpep8
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/WoLpH/portalocker/commit/7741925738c7e66ae9c4a0944a04b6a3088037d5.patch";
      sha256 = "1g95rnfbnagkkk9qfzzd5346dl3clbgjnzr2wk09m0wphds7zd8z";
    })
  ];

  meta = with lib; {
    description = "A library to provide an easy API to file locking";
    homepage = https://github.com/WoLpH/portalocker;
    license = licenses.psfl;
    maintainers = with maintainers; [ jonringer ];
    platforms = platforms.unix; # Windows has a dependency on pypiwin32
  };
}
