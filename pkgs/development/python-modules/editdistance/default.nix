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
    rev = version;
    sha256 = "1qajskfyx2ki81ybksf0lgl1pdyw7al4ci39zrj66ylsn8fssg89";
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
