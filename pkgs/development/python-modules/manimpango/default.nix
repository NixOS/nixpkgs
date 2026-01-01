{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,
  setuptools,
  pango,
  cython,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "manimpango";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "0.6.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ManimCommunity";
    repo = "manimpango";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-8eQmhVsW440/zxOwjngnPTGT7iFbdSvBV7tnI332piE=";
=======
    hash = "sha256-nN+XOnki8fG7URMy2Fhs2X+yNi8Y7wDo53d61xaRa3w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython>=3.0.2,<3.1" Cython
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ pango ];

  build-system = [
    setuptools
    cython
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  preCheck = ''
    rm -r manimpango
  '';

  pythonImportsCheck = [ "manimpango" ];

<<<<<<< HEAD
  meta = {
    description = "Binding for Pango";
    homepage = "https://github.com/ManimCommunity/ManimPango";
    changelog = "https://github.com/ManimCommunity/ManimPango/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilytrau ];
=======
  meta = with lib; {
    description = "Binding for Pango";
    homepage = "https://github.com/ManimCommunity/ManimPango";
    changelog = "https://github.com/ManimCommunity/ManimPango/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
