{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,
  setuptools,
  pango,
  cython,
  AppKit,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "manimpango";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ManimCommunity";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-nN+XOnki8fG7URMy2Fhs2X+yNi8Y7wDo53d61xaRa3w=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ pango ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ AppKit ];

  build-system = [
    setuptools
    cython
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    rm -r manimpango
  '';

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov --no-cov-on-fail" ""
  '';

  pythonImportsCheck = [ "manimpango" ];

  meta = with lib; {
    description = "Binding for Pango";
    homepage = "https://github.com/ManimCommunity/ManimPango";
    changelog = "https://github.com/ManimCommunity/ManimPango/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
  };
}
