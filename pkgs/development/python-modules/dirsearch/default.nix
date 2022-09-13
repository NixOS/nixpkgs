{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, pysocks
, jinja2
, certifi
, urllib3
, cryptography
, defusedxml
, pyopenssl
, chardet
, charset-normalizer
, requests
, requests_ntlm
, colorama
, beautifulsoup4
, pyparsing
, setuptools
}:

buildPythonPackage rec {
  pname = "dirsearch";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "maurosoria";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-eXB103qUB3m7V/9hlq2xv3Y3bIz89/pGJsbPZQ+AZXs=";
  };

  doCheck = false; # disabled because of TypeError: DynamicContentParser.__init__() missing 4 required positional arguments: 'requester', 'path', 'firstPage', and 'secondPage', also appears to require network connection

  buildInputs = [ python ];

  propagatedBuildInputs = [ pysocks jinja2 certifi urllib3 cryptography defusedxml pyopenssl chardet charset-normalizer requests requests_ntlm colorama beautifulsoup4 pyparsing setuptools ];

  pythonImportsCheck = [
    "socks" "jinja2" "certifi" "urllib3" "cryptography" "cffi" "defusedxml" "markupsafe"
    "OpenSSL" "idna" "chardet" "charset_normalizer" "requests" "requests_ntlm" "colorama" "ntlm_auth" "pyparsing" "bs4" "setuptools"
  ];

  # installPhase was overridden because of the "[....]/nix-support/setup-hook: line 13: pushd: dist: No such file or directory" error
  installPhase = ''
    ${python.pythonForBuild.interpreter} -m pip install --no-build-isolation --no-index --prefix=$out  --ignore-installed --no-dependencies --no-cache .
  '';

  meta = with lib; {
    description = "An advanced command-line tool designed to brute force directories and files in webservers, AKA web path scanner.";
    homepage = "https://github.com/maurosoria/dirsearch";
    changelog = "https://github.com/maurosoria/dirsearch/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [];
  };
}

