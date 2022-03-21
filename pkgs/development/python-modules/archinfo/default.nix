{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, nose
, pythonOlder
}:

buildPythonPackage rec {
  pname = "archinfo";
  version = "9.1.12332";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nv/hwQZgKv/cM8fF6GqI8zY9GAe8aCZ/AGFOmhz+bMM=";
  };

  checkInputs = [
    nose
    pytestCheckHook
  ];

  patches = [
    # Make archinfo import without installing pyvex, https://github.com/angr/archinfo/pull/113
    (fetchpatch {
      name = "fix-import-issue.patch";
      url = "https://github.com/angr/archinfo/commit/d29c108f55ffd458ff1d3d65db2d651c76b19267.patch";
      sha256 = "sha256-9vi0QyqQLIPQxFuB8qrpcnPXWOJ6d27/IXJE/Ui6HhM=";
    })
  ];

  pythonImportsCheck = [
    "archinfo"
  ];

  meta = with lib; {
    description = "Classes with architecture-specific information";
    homepage = "https://github.com/angr/archinfo";
    license = with licenses; [ bsd2 ];
    maintainers = [ maintainers.fab ];
  };
}
