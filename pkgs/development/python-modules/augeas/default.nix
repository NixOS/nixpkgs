{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  unittestCheckHook,
  pkg-config,
  augeas,
  cffi,
  pkgs, # for libxml2
}:
buildPythonPackage rec {
  pname = "augeas";
  version = "1.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hercules-team";
    repo = "python-augeas";
    rev = "v${version}";
    hash = "sha256-Lq8ckra3sqN38zo1d5JsEq6U5TtLKRmqysoWNwR9J9A=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    augeas
    pkgs.libxml2
  ];

  propagatedBuildInputs = [ cffi ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "augeas" ];

  meta = with lib; {
    changelog = "https://github.com/hercules-team/python-augeas/releases/tag/v${version}";
    description = "Pure python bindings for augeas";
    homepage = "https://github.com/hercules-team/python-augeas";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
