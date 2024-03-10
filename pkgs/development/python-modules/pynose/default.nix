{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
}:

buildPythonPackage rec {
  pname = "pynose";
  version = "1.4.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mdmintz";
    repo = "pynose";
    rev = "v${version}";
    hash = "sha256-V6jZBEkEAKzClA/3s+Lyfm9xExgCEJbLCNnIHmZ94E4=";
  };

  nativeBuildInputs = [ setuptools ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "pynose fixes nose to extend unittest and make testing easier";
    homepage = "https://github.com/mdmintz/pynose";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
