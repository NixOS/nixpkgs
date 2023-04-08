{ lib
, buildPythonPackage
, fetchFromGitHub
, fpyutils
, pyfakefs
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "md-toc";
  version = "8.1.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frnmst";
    repo = pname;
    rev = version;
    hash = "sha256-t3G8nQCVUUuDb+W+Gw+f2miXQ2i/hdVfT6yGxdNWKpw=";
  };

  propagatedBuildInputs = [
    fpyutils
  ];

  nativeCheckInputs = [
    pyfakefs
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "md_toc/tests/*.py"
  ];

  pythonImportsCheck = [
    "md_toc"
  ];

  meta = with lib; {
    description = "Table of contents generator for Markdown";
    homepage = "https://docs.franco.net.eu.org/md-toc/";
    changelog = "https://blog.franco.net.eu.org/software/CHANGELOG-md-toc.html";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
