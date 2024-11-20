{ python3Packages, lib }:

python3Packages.buildPythonPackage rec {
  pname = "mawk";
  version = "0.1.4";
  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-ThFbL36ul0Br8jYLr7oi7+4D0p/ymENqadtQaxU10vE=";
  };

  pyproject = true;

  nativeBuildInputs = [
    python3Packages.poetry-core
  ];

  meta = {
    description = "Python implementation of a line processor with Awk-like semanticsn";
    homepage = "https://github.com/jhidding/mawk";
    maintainers = with lib.maintainers; [ mgttlinger ];
    platforms = python3Packages.python.meta.platforms;
    license = lib.licenses.asl20;
  };
}
