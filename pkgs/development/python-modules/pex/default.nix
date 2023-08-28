{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, flit-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pex";
  version = "2.1.144";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wugHG/ZfyfNgd2znDS7FXu34LsUVMcwDswFkh4lRIXo=";
  };

  patches = [
    # https://github.com/pantsbuild/pex/pull/2229
    (fetchpatch {
      name = "unpin-flit-core-dependency.patch";
      url = "https://github.com/pantsbuild/pex/commit/02754ddd43b9ed81c8bda557bef7516dc37da3e5.patch";
      hash = "sha256-9FHObjtA7cgh8/vltPGyrhENJotHeM08RxTUwQ3y/38=";
    })
  ];

  nativeBuildInputs = [
    flit-core
  ];

  # A few more dependencies I don't want to handle right now...
  doCheck = false;

  pythonImportsCheck = [
    "pex"
  ];

  meta = with lib; {
    description = "Python library and tool for generating .pex (Python EXecutable) files";
    homepage = "https://github.com/pantsbuild/pex";
    changelog = "https://github.com/pantsbuild/pex/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin phaer ];
  };
}
