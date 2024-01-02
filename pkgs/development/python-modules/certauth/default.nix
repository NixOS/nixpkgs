{ lib
, buildPythonPackage
, fetchFromGitHub
, pyopenssl
, tldextract
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "certauth";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ikreymer";
    repo = "certauth";
    # Repo has no git tags, https://github.com/ikreymer/certauth/issues/15
    rev = "ad2bae5d40a9e45519fc1f2cd7678174bbc55b3d";
    hash = "sha256-Rso5N0jb9k7bdorjPIUMNiZZPnzwbkxFNiTpsJ9pco0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "--cov certauth " ""
  '';

  propagatedBuildInputs = [
    pyopenssl
    tldextract
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "certauth"
  ];

  disabledTests = [
    # Tests want to download Public Suffix List
    "test_file_wildcard"
    "test_file_wildcard_subdomains"
    "test_in_mem_parent_wildcard_cert"
    "test_in_mem_parent_wildcard_cert_at_tld"
    "test_in_mem_parent_wildcard_cert_2"
  ];

  meta = with lib; {
    description = "Simple CertificateAuthority and host certificate creation, useful for man-in-the-middle HTTPS proxy";
    homepage = "https://github.com/ikreymer/certauth";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
