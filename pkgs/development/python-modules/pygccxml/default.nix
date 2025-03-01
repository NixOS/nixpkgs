{
  lib,
  castxml,
  fetchFromGitHub,
  buildPythonPackage,
  llvmPackages,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pygccxml";
  version = "2.6.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gccxml";
    repo = "pygccxml";
    tag = "v${version}";
    hash = "sha256-SVlzgIlaKVbnestxTJX2yjVaspZ6fq5bBokRy8jzD3Q=";
  };

  nativeBuildInputs = [ setuptools ];

  buildInputs = [
    castxml
    llvmPackages.libcxxStdenv
  ];

  # running the suite is hard, needs to generate xml_generator.cfg
  # but the format doesn't accept -isystem directives
  doCheck = false;

  meta = with lib; {
    description = "Python package for easy C++ declarations navigation";
    homepage = "https://github.com/gccxml/pygccxml";
    changelog = "https://github.com/CastXML/pygccxml/blob/v${version}/CHANGELOG.md";
    license = licenses.boost;
    maintainers = with maintainers; [ teto ];
  };
}
