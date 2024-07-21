{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pygobject3,
  dbus,
  hatchling,
  pytestCheckHook,
  unstableGitUpdater,
}:

buildPythonPackage rec {
  pname = "dasbus";
  version = "0-unstable-2023-07-10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "dasbus";
    rev = "be51b94b083bad6fa0716ad6dc97d12f4462f8d4";
    hash = "sha256-9nDH9S5addyl1h6G1UTRTSKeGfRo+8XRPq2BdgiZD24=";
  };

  nativeBuildInputs = [ hatchling ];
  propagatedBuildInputs = [ pygobject3 ];
  nativeCheckInputs = [
    dbus
    # causes build failure at pytestCheckPhase, FIXME: remove in future
    # pytestCheckHook
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = with lib; {
    homepage = "https://github.com/rhinstaller/dasbus";
    description = "DBus library in Python3";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ moni ];
  };
}
