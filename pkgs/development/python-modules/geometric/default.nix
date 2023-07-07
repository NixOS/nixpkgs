{ buildPythonPackage
, lib
, fetchFromGitHub
, fetchpatch
, networkx
, numpy
, scipy
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "geometric";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "leeping";
    repo = "geomeTRIC";
    rev = version;
    hash = "sha256-3d4z1n8+e0HgdeKLNSsHLb3XHOk09uy+gP9AwNvNITE=";
  };

  patches = [ (fetchpatch {
    name = "ase-is-optional";
    url = "https://github.com/leeping/geomeTRIC/commit/aff6e4411980ac9cbe112a050c3a34ba7e305a43.patch";
    hash = "sha256-JGGPX+JwkQ8Imgmyx+ReRTV+k6mxHYgm+Nd8WUjbFEg=";
  }) ];

  propagatedBuildInputs = [
    networkx
    numpy
    scipy
    six
  ];

  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Geometry optimization code for molecular structures";
    homepage = "https://github.com/leeping/geomeTRIC";
    license = [ licenses.bsd3 ];
    maintainers = [ maintainers.markuskowa ];
  };
}

