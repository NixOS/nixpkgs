{
  lib,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonPackage rec {
  pname = "bindep";
  version = "2.11.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rLLyWbzh/RUIhzR5YJu95bmq5Qg3hHamjWtqGQAufi8=";
  };

  buildInputs = with python3Packages; [
    distro
    pbr
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    parsley
    pbr
    packaging
    distro
  ];

  patchPhase = ''
    # Setting the pbr version will skip any version checking logic
    # This is required because pbr thinks it gets it's own version from git tags
    # See https://docs.openstack.org/pbr/latest/user/packagers.html
    export PBR_VERSION=5.11.1
  '';

  meta = with lib; {
    description = "Bindep is a tool for checking the presence of binary packages needed to use an application / library";
    homepage = "https://docs.opendev.org/opendev/bindep/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ melkor333 ];
  };
}
