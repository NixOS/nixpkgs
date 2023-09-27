{ lib
, castxml
, fetchFromGitHub
, buildPythonPackage
, llvmPackages
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pygccxml";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gccxml";
    repo = "pygccxml";
    rev = "refs/tags/v${version}";
    hash = "sha256-rw99afv68c92LWmKUErB1y0Cts69UEpI0GCxSMvD+B8=";
  };

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
