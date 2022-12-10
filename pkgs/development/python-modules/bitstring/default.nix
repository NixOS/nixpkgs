{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "bitstring";
  version = "3.1.9";

  src = fetchFromGitHub {
    owner = "scott-griffiths";
    repo = pname;
    rev = "bitstring-${version}";
    sha256 = "0y2kcq58psvl038r6dhahhlhp1wjgr5zsms45wyz1naq6ri8x9qa";
  };

  patches = [
    (fetchpatch {
      name = "fix-running-unit-tests-using-unittest-hook.patch";
      url = "https://github.com/scott-griffiths/bitstring/commit/e5ee3fd41cad2ea761f4450b13b0424ae7262331.patch";
      hash = "sha256-+ZGywIfQQcYXJlYZBi402ONnysYm66G5zE4duJE40h8=";
    })
  ];

  checkInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-s" "test" ];

  pythonImportsCheck = [ "bitstring" ];

  meta = with lib; {
    description = "Module for binary data manipulation";
    homepage = "https://github.com/scott-griffiths/bitstring";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
