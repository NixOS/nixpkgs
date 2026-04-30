{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  more-itertools,
  base58,
  requests,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "scalecodec";
  version = "1.2.12";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JAMdotTech";
    repo = "py-scale-codec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e6SDVivkVZjL84kcvkPs+5S2iD79+p+dGjhUWuS50Fc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    more-itertools
    base58
    requests
  ];

  # setup.py reads version from TRAVIS_TAG env var
  env.TRAVIS_TAG = finalAttrs.src.tag;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "scalecodec" ];

  meta = {
    description = "Python SCALE Codec Library";
    longDescription = "Substrate uses a lightweight and efficient encoding and decoding program to optimize how data is sent and received over the network. The program used to serialize and deserialize data is called the SCALE codec, with SCALE being an acronym for Simple Concatenated Aggregate Little-Endian.";
    homepage = "https://github.com/JAMdotTech/py-scale-codec";
    changelog = "https://github.com/JAMdotTech/py-scale-codec/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kilyanni ];
  };
})
