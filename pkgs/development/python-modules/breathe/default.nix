{ lib
, buildPythonPackage
, docutils
, fetchFromGitHub
, fetchpatch
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

  patches = [
    (fetchpatch {
      url = "https://github.com/breathe-doc/breathe/commit/de3504c81c7cefc87c8229743f93232ca00a685d.patch";
      hash = "sha256-UGld5j0F/hnTuS7KUFvgQL52xCUdaJ3/NeuEuHhpCxI=";
    })
  ];

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
