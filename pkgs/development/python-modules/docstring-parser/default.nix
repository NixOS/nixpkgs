{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, wheel
, pytest
}: buildPythonPackage rec {
  pname = "docstring-parser";
  version = "0.12";
  src = fetchFromGitHub {
    owner = "rr-";
    repo = "docstring_parser";
    rev = "${version}";
    sha256 = "sha256-hQuPJQrGvDs4dJrMLSR4sSnqy45xrF2ufinBG+azuCg=";
  };
  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ pytest setuptools wheel ];
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  meta = with lib; {
    description = "Parse Python docstrings in various flavors. ";
    homepage = "https://github.com/rr-/docstring_parser";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
