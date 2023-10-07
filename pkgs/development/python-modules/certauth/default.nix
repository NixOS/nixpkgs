{ lib
, buildPythonPackage
, fetchFromGitHub
, pyopenssl
, tldextract
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "certauth";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ikreymer";
    repo = "certauth";
    rev = "ad2bae5d40a9e45519fc1f2cd7678174bbc55b3d"; # Repo has no git tags
    hash = "sha256-Rso5N0jb9k7bdorjPIUMNiZZPnzwbkxFNiTpsJ9pco0=";
  };

  propagatedBuildInputs = [
    pyopenssl
    tldextract
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [ "certauth" ];

  meta = with lib; {
    description = "Simple CertificateAuthority and host certificate creation, useful for man-in-the-middle HTTPS proxy";
    homepage = "https://github.com/ikreymer/certauth";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
