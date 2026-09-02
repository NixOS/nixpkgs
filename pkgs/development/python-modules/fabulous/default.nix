{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pillow,
  setuptools,
  python,
}:

buildPythonPackage rec {
  pname = "fabulous";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jart";
    repo = "fabulous";
    rev = version;
    hash = "sha256-hchlxuB5QP+VxCx+QZ2739/mR5SQmYyE+9kXLKJ2ij4=";
  };

  patches = [
    ./relative_import.patch
    # https://github.com/jart/fabulous/pull/22
    (fetchpatch2 {
      url = "https://github.com/jart/fabulous/commit/5779f2dfbc88fd81b5b5865247913d4775e67959.patch?full_index=1";
      hash = "sha256-miWFt4vDpwWhSUgnWDjWUXoibijcDa1c1dDOSkfWoUg=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ pillow ];

  checkPhase = ''
    for i in tests/*.py; do
      ${python.interpreter} $i
    done
  '';

  meta = {
    description = "Make the output of terminal applications look fabulous";
    homepage = "https://jart.github.io/fabulous";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.symphorien ];
  };
}
