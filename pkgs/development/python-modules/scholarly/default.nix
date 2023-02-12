{ lib
, buildPythonPackage
, fetchFromGitHub
, unittestCheckHook

, arrow
, beautifulsoup4
, bibtexparser
, deprecated
, fake-useragent
, free-proxy
, httpx
, python-dotenv
, selenium
, sphinx-rtd-theme
, typing-extensions
}:

buildPythonPackage rec {
  pname = "scholarly";
  version = "1.7.11";

  # Pypi does not contain tests
  src = fetchFromGitHub {
    owner = "scholarly-python-package";
    repo = pname;
    rev = "v${version}";
    sha256 = lib.fakeHash;
  };

  propagatedBuildInputs = [
    arrow
    beautifulsoup4
    bibtexparser
    deprecated
    fake-useragent
    free-proxy
    httpx
    python-dotenv
    selenium
    sphinx-rtd-theme
    typing-extensions
  ];

  checkPhase = ''
    runHook preCheck

    python test_module.py

    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/scholarly-python-package/scholarly";
    description = "Simple access to Google Scholar authors and citations";
    license = with licenses; [ unlicense ];
    maintainers = with maintainers; [ pkosel ];
  };
}
