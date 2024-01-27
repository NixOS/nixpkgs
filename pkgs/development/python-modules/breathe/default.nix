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
      # sphinx 7.2 support https://github.com/breathe-doc/breathe/pull/956
      name = "breathe-sphinx7.2-support.patch";
      url = "https://github.com/breathe-doc/breathe/commit/46abd77157a2a57e81586e4f8765ae8f1a09d167.patch";
      hash = "sha256-zGFO/Ndk/9Yv2dbo8fpEoB/vchZP5vRceoC1E3sUny8=";
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
