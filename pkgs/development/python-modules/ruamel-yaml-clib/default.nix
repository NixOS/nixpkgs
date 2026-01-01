{
  lib,
  buildPythonPackage,
  fetchhg,
  setuptools,
  cython,
}:

buildPythonPackage rec {
  pname = "ruamel-yaml-clib";
<<<<<<< HEAD
  version = "0.2.14";
=======
  version = "0.2.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchhg {
    url = "http://hg.code.sf.net/p/ruamel-yaml-clib/code";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-fy+nzq/L3OKGujf6ExDowdxTWDnZGzVnDxL2e5t0Xcs=";
=======
    hash = "sha256-VKiNt2WJttVjMR0z4bvdSYKOZqycRONCSPQacAy5PYo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  # no tests
  doCheck = false;

  # circular dependency with ruamel-yaml
  # pythonImportsCheck = [ "_ruamel_yaml" ];
  nativeBuildInputs = [ cython ];

  preBuild = "cython _ruamel_yaml.pyx -3 --module-name _ruamel_yaml -I.";

<<<<<<< HEAD
  meta = {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml-clib/";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml-clib/";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
