{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pytun";
  version = "2.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "montag451";
    repo = "pytun";
    sha256 = "sha256-DZ7CoLi6LPhuc55HF9dtek+/N4A29ecnZn7bk7jweuI=";
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
