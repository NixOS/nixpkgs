{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pygmars";
  version = "0.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-PiH1lV1Vt9VTSOB+jep8FHIdk8qnauxj4nP3CIi/m7o=";
  };

  postPatch = ''
    # https://github.com/nexB/pygmars/pull/9
    substituteInPlace setup.cfg \
      --replace ">=3.6.*" ">=3.6"
  '';

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pygmars"
  ];

  meta = with lib; {
    description = "Python lexing and parsing library";
    homepage = "https://github.com/nexB/pygmars";
    changelog = "https://github.com/nexB/pygmars/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
