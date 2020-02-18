{ lib, buildPythonPackage, fetchFromGitHub, isPy27, nose, clang }:

buildPythonPackage rec {
  pname = "scan-build";
  version = "2.0.18";
  disabled = isPy27;

  src = fetchFromGitHub{
    owner = "rizsotto";
    repo = pname;
    rev = version;
    sha256 = "1fpmpg41314qwy6prwknh0hkclcqc1lm7lbmh4r8scsfzs3zch6b";
  };

  # ignore odd clang tests
  checkInputs = [ nose clang ];
  checkPhase = "nosetests -e test_get_clang_arguments_fails tests/unit";

  meta = with lib; {
    homepage = "https://github.com/rizsotto/scan-build";
    license = licenses.ncsa;
    description = "Static code analyzer wrapper for Clang";
    maintainers = with maintainers; [ malo ];
  };
}
