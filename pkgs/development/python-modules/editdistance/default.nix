{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, cython
}:

buildPythonPackage rec {
  pname = "editdistance";
  version = "0.5.3";


  src = fetchFromGitHub {
    owner = "roy-ht";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vk8vz41p2cs7s7zbaw3cnw2jnvy5rhy525xral68dh14digpgsd";
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
