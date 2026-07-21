{
  lib,
  buildPythonPackage,
  fetchPypi,
  mistune,
  cjkwrap,
  wcwidth,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "md2gemini";
  version = "1.9.1";
  format = "setuptools";

  propagatedBuildInputs = [
    mistune
    cjkwrap
    wcwidth
  ];
  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "md2gemini" ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XreDqqzH3UQ+RIBOrvHpaBb7PXcPPptjQx5cjpI+VzQ=";
  };

  meta = {
    description = "Markdown to Gemini text format conversion library";
    homepage = "https://github.com/makeworld-the-better-one/md2gemini";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.kaction ];
    broken = lib.versionAtLeast mistune.version "3";
  };
}
