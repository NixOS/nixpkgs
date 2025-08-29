{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "lazy-object-proxy";
  version = "1.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ionelmc";
    repo = "python-lazy-object-proxy";
    tag = "v${version}";
    hash = "sha256-iOftyGx5wLxIUwlmo1lY06MXqgxfZek6RR1S5UydOEs=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Broken tests. Seem to be fixed upstream according to Travis.
  doCheck = false;

  meta = with lib; {
    description = "Fast and thorough lazy object proxy";
    homepage = "https://github.com/ionelmc/python-lazy-object-proxy";
    license = with licenses; [ bsd2 ];
  };
}
