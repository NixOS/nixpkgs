{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

let
  pname = "boilerpy3";
  version = "1.0.7";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jmriebold";
    repo = "BoilerPy3";
    tag = "v${version}";
    hash = "sha256-dhAB0VbBGsSrgYGUlZEYaKA6sQB/f9Bb3alsRuQ8opo=";
  };

  postPatch = ''
    # the version mangling in mautrix_signal/get_version.py interacts badly with pythonRelaxDepsHook
    substituteInPlace setup.py \
      --replace '>=3.6.*' '>=3.6'
  '';

  pythonImportsCheck = [ "boilerpy3" ];

  meta = {
    homepage = "https://github.com/jmriebold/BoilerPy3";
    description = "Python port of Boilerpipe library";
    changelog = "https://github.com/jmriebold/BoilerPy3/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
