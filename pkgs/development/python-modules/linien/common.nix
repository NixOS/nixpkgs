{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, propagatedBuildInputs ? []
, nativeBuildInputs ? []
, preFixup ? ""
, numpy
, plumbum
, rpyc
, scipy
, pytestCheckHook
, pytest-plt
, matplotlib
, migen
, misoc
}:

# subprj is either "GUI" / "Client" / "Server" - they are turned into lower
# case in most usages
subproject: let
  subprj = lib.toLower subproject;
  version = "0.5.3";
# Not using rec to differentiate inputs from callPackage arguments to inputs
# from buildPythonPackage arguments
in buildPythonPackage {
  pname = "linien-${subprj}";
  inherit version;
  # The pypi package named `linien` contains only the gui python package, and
  # it doesn't contain the tests. Using this src, we get the tests and we can
  # build all linien-* packages with the same src.
  src = fetchFromGitHub {
    owner = "linien-org";
    repo = "linien";
    rev = "v${version}";
    hash = "sha256-VOT/mw4o9dbkrtMxL0Ar5UcnxsZ7CYcoTj+VVrWADR4=";
  };
  patches = [
    # Removes unrequired uuid dependency, see:
    # https://github.com/linien-org/linien/pull/289
    (fetchpatch {
      url = "https://github.com/doronbehar/linien/commit/58fd44aee33858b5550e239039a96e6df5a31b2a.patch";
      hash = "sha256-hg6bNSLcYruD3f3owo4aKeuRfhABTPZej3gPOJKrQ54=";
    })
  ] ++ lib.optionals (subprj == "gui") [
    # From some reason upstream didn't add the linien.client package which is
    # needed when running the gui - it's also unavailable in the pypi package
    # named `linien`. See https://github.com/linien-org/linien/issues/290
    ./add-client-python-package-to-gui.patch
  ];
  postPatch = ''
    # Fool the python builder
    ln -s setup_${subprj}.py setup.py
    # Add a missing VERSION file to fix build not from pypi
    echo ${version} > linien/VERSION
    # Remove dependencies pinning, doesn't remove pinning of linien-client
    sed -i -E 's/([a-zA-Z0-9])[><=]{2}.*",/\1",/g' setup_${subprj}.py
  '';

  propagatedBuildInputs = propagatedBuildInputs ++ [
    numpy
    plumbum
    rpyc
    scipy
  ];

  # The tests are identical to all subprojects and they take a long time, so
  # run them only for one of the subprojects.
  doCheck = (subprj == "server");
  checkInputs = [
    pytestCheckHook
    pytest-plt
    matplotlib
    migen
    misoc
  ];

  inherit
    nativeBuildInputs
    preFixup
  ;

  meta = with lib; {
    description = "Spectroscopy lock application using RedPitaya: ${subproject}";
    homepage = "https://github.com/linien-org/linien";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ doronbehar ];
  };
}
