{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  ruamel-base,
  ruamel-yaml-clib,
  isPyPy,
}:

buildPythonPackage rec {
  pname = "ruamel-yaml";
<<<<<<< HEAD
  version = "0.18.16";
=======
  version = "0.18.14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    pname = "ruamel.yaml";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-puWHUS88mYsiJdaKofNREcKfrRSu1WGibnP6tynsXlo=";
=======
    hash = "sha256-cie3aq7DZN8Vk2cw7799crMMC3mx1Xi7uOPcstgfUrc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ setuptools ];

  # Tests use relative paths
  doCheck = false;

  propagatedBuildInputs = [ ruamel-base ] ++ lib.optional (!isPyPy) ruamel-yaml-clib;

  pythonImportsCheck = [ "ruamel.yaml" ];

<<<<<<< HEAD
  meta = {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml/";
    changelog = "https://sourceforge.net/p/ruamel-yaml/code/ci/default/tree/CHANGES";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml/";
    changelog = "https://sourceforge.net/p/ruamel-yaml/code/ci/default/tree/CHANGES";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
