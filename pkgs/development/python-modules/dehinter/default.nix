{ lib
, buildPythonPackage
, fetchFromGitHub
, fonttools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dehinter";
  version = "4.0.0";
  format = "setuptools";

  # PyPI source tarballs omit tests, fetch from Github instead
  src = fetchFromGitHub {
    owner = "source-foundry";
    repo = "dehinter";
    rev = "v${version}";
    hash = "sha256-l988SW6OWKXzJK0WGAJZR/QDFvgnSir+5TwMMvFcOxg=";
  };

  propagatedBuildInputs = [
    fonttools
  ];

  doCheck = true;
  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Utility for removing hinting data from TrueType and OpenType fonts";
    homepage = "https://github.com/source-foundry/dehinter";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}

