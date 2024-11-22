{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  python,
  fetchPypi,
  setuptools,
  pkgs,
}:

buildPythonPackage rec {
  pname = "bsddb3";
  version = "6.2.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "70d05ec8dc568f42e70fc919a442e0daadc2a905a1cfb7ca77f549d49d6e7801";
  };

  build-system = [ setuptools ];

  buildInputs = [ pkgs.db ];

  # See : https://github.com/NixOS/nixpkgs/pull/311198#discussion_r1599257522
  # More details here : https://www.jcea.es/programacion/pybsddb.htm
  disabled = pythonAtLeast "3.10";

  # Path to database need to be set.
  # Somehow the setup.py flag is not propagated.
  #setupPyBuildFlags = [ "--berkeley-db=${pkgs.db}" ];
  # We can also use a variable
  preConfigure = ''
    export BERKELEYDB_DIR=${pkgs.db.dev};
  '';

  postPatch = ''
    substituteInPlace test3.py \
      --replace-fail "from distutils.util import get_platform" "from sysconfig import get_platform" \
      --replace-fail "sys.config[0:3]" "sys.implementation.cache_tag"
  '';

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  meta = with lib; {
    description = "Python bindings for Oracle Berkeley DB";
    homepage = "https://www.jcea.es/programacion/pybsddb.htm";
    license = with licenses; [ agpl3Only ]; # License changed from bsd3 to agpl3 since 6.x
    maintainers = [ ];
  };
}
