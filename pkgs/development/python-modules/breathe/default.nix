{ lib
, buildPythonPackage
, docutils
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, sphinx
}:

buildPythonPackage rec {
  pname = "breathe";
  version = "4.35.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "michaeljones";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-LJXvtScyWRL8zfj877bJ4xuIbLV9IN3Sn9KPUTLMjMI=";
  };

  propagatedBuildInputs = [
    docutils
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "breathe"
  ];

  meta = with lib; {
    description = "Sphinx Doxygen renderer";
    homepage = "https://github.com/michaeljones/breathe";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    inherit (sphinx.meta) platforms;
  };
}
