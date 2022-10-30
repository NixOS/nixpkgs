{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, cython
}:

buildPythonPackage rec {
  pname = "editdistance";
  version = "0.6.1";


  src = fetchFromGitHub {
    owner = "roy-ht";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-c0TdH1nJAKrepatCSCTLaKsDv9NKruMQadCjclKGxBw=";
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
