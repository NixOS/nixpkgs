{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, iocapture
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "argh";
  version = "0.26.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e9535b8c84dc9571a48999094fda7f33e63c3f1b74f3e5f3ac0105a58405bb65";
  };

  patches = [
    # https://github.com/neithere/argh/issues/148
    (fetchpatch {
      name = "argh-0.26.2-fix-py3.9-msgs.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-python/argh/files/argh-0.26.2-fix-py3.9-msgs.patch?id=6f194f12a2e30aad7da347848f7b0187e188f983";
      sha256 = "nBmhF2PXVeS7cBNujzip6Bb601LRHrjmhlGKFr/++Oo=";
    })
  ];

  nativeCheckInputs = [
    iocapture
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "argh" ];

  meta = with lib; {
    homepage = "https://github.com/neithere/argh";
    description = "An unobtrusive argparse wrapper with natural syntax";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ domenkozar ];
  };
}
