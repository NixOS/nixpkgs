{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pytun";
  version = "2.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "montag451";
    repo = "pytun";
    sha256 = "1cqq8aci38058fjh4a0xf21wac177fw576p2yjl2b8jd9rnsqbl5";
  };

  # Test directory contains examples, not tests.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/montag451/pytun";
    description = "Linux TUN/TAP wrapper for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ montag451 ];
    platforms = platforms.linux;
  };
}
