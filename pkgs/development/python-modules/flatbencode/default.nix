{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flatbencode";
  version = "0.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "acatton";
    repo = "flatbencode";
    rev = "v${version}";
    hash = "sha256-1/4w41E8IKygJTBcQOexiDytV6BvVBwIjajKz2uCfu8=";
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "flatbencode" ];

  meta = {
    description = "Fast, safe and non-recursive implementation of Bittorrent bencoding";
    homepage = "https://github.com/acatton/flatbencode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
