{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  cffi,
}:

buildPythonPackage rec {
  pname = "editdistance-s";
  version = "1.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "0w2qd5b6a3c3ahd0xy9ykq4wzqk0byqwdqrr26dyn8j2425j46lg";
  };

  propagatedNativeBuildInputs = [ cffi ];

  propagatedBuildInputs = [ cffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "editdistance_s" ];

  meta = with lib; {
    description = "Fast implementation of the edit distance (Levenshtein distance)";
    homepage = "https://github.com/asottile/editdistance-s";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ austinbutler ];
  };
}
