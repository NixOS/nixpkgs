{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,
  setuptools,
}:

buildPythonPackage rec {
  pname = "humanfriendly";
  version = "10.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-awuDHOjxX3MAchqkmCn8ToOSGpowHMf2Br5mhqIojdw=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/xolox/python-humanfriendly/pull/75
      url = "https://github.com/musicinmybrain/python-humanfriendly/commit/13d05b8057010121acd2a402a337ef4ee5834062.patch";
      hash = "sha256-m7cySiIx0gNhh6KKhT71DJFOtFu2Copk9ic2yaiCulk=";
    })
  ];

  build-system = [ setuptools ];

  # humanfriendly tests depends on coloredlogs which itself depends on
  # humanfriendly. This lead to infinite recursion when trying to
  # build this package so we have to disable the test suite :(
  doCheck = false;

  meta = with lib; {
    description = "Human friendly output for text interfaces using Python";
    mainProgram = "humanfriendly";
    homepage = "https://humanfriendly.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ montag451 ];
  };
}
