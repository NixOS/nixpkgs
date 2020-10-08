{ stdenv
, buildPythonPackage
, isPy27
, fetchPypi
, substituteAll
, pkgs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "libevdev";
  version = "0.9";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "17agnigmzscmdjqmrylg1lza03hwjhgxbpf4l705s6i7p7ndaqrs";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      libevdev = stdenv.lib.getLib pkgs.libevdev;
    })
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with stdenv.lib; {
    description = "Python wrapper around the libevdev C library";
    homepage = "https://gitlab.freedesktop.org/libevdev/python-libevdev";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu ];
  };
}
