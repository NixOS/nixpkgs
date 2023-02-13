{ lib, fetchFromGitHub, buildPythonPackage
, python, isPy3k, unittestCheckHook }:

buildPythonPackage rec {
  pname = "emailthreads";
  version = "0.1.3";
  disabled = !isPy3k;

  # pypi is missing files for tests
  src = fetchFromGitHub {
    owner = "emersion";
    repo = "python-emailthreads";
    rev = "v${version}";
    sha256 = "sha256-7BhYS1DQCW9QpG31asPCq5qPyJy+WW2onZpvEHhwQCs=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  PKGVER = version;

  meta = with lib; {
    homepage = "https://github.com/emersion/python-emailthreads";
    description = "Python library to parse and format email threads";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
