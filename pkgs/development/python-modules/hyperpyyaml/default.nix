{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pyyaml
, ruamel-yaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hyperpyyaml";
  version = "1.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "speechbrain";
    repo = "hyperpyyaml";
    rev = "refs/tags/v${version}";
    hash = "sha256-tC4kLJAY9MVgjWwU2Qu0rPCVDw7CjKVIciRZgYhnR9I=";
  };

  patches = [
    # This patch is needed to comply with the newer versions of ruamel.yaml.
    # PR to upstream this change: https://github.com/speechbrain/HyperPyYAML/pull/23
    (fetchpatch {
      url = "https://github.com/speechbrain/HyperPyYAML/commit/95c6133686c42764770a77429eab55f6dfe5581c.patch";
      hash = "sha256-WrHDo17f5pYNXSSqI8t1tlAloYms9oLFup7D2qCKwWw=";
    })
  ];

  propagatedBuildInputs = [
    pyyaml
    ruamel-yaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hyperpyyaml" ];

  meta = with lib; {
    description = "Extensions to YAML syntax for better python interaction";
    homepage = "https://github.com/speechbrain/HyperPyYAML";
    changelog = "https://github.com/speechbrain/HyperPyYAML/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
