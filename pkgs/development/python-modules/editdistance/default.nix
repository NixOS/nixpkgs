{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, cython
}:

buildPythonPackage rec {
  pname = "editdistance";
  version = "0.6.0";


  src = fetchFromGitHub {
    owner = "roy-ht";
    repo = pname;
    rev = "v${version}";
    sha256 = "17xkndwdyf14nfxk25z1qnhkzm0yxw65fpj78c01haq241zfzjr5";
  };

  nativeBuildInputs = [ cython ];

  preBuild = ''
    cythonize --inplace editdistance/bycython.pyx
  '';

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "editdistance" ];

  meta = with lib; {
    description = "Python implementation of the edit distance (Levenshtein distance)";
    homepage = "https://github.com/roy-ht/editdistance";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
